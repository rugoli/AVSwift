//
//  AVStockDataFetcher.swift
//  AVSwift
//
//  Created by Roshan on 1/2/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit
import Foundation

fileprivate protocol StockResultsParser {
  associatedtype ModelType
  static func parse(
    input: UnparsedStockResults,
    withFilters modelFilters: [ModelFilter<ModelType>],
    config: AVStockFetcherConfiguration) throws -> [ModelType?]
}

fileprivate let metadataKey: String = "Metadata"
public typealias ModelFilter<T> = (T) -> Bool
public typealias ParsedStockCompletion<M> = ([M]?, Error?) -> Void
public typealias UnparsedStockResults = [String: [String: String]]
public typealias UnparsedStockCompletion = (UnparsedStockResults?, Error?) -> Void

public struct AVStockFetcherConfiguration {
  let fetchQueue: DispatchQueue
  let callbackQueue: DispatchQueue
  let failOnParsingError: Bool
  
  public init(fetchQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated),
              callbackQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated),
              failOnParsingError: Bool = false) {
    self.fetchQueue = fetchQueue
    self.callbackQueue = callbackQueue
    self.failOnParsingError = failOnParsingError
  }
}

// MARK: Public

public class AVStockDataFetcher<ModelType: Decodable & AVDateOrderable>: NSObject {
  let url: URL
  let filters: [ModelFilter<ModelType>]
  
  public init(url: URL, filters: [ModelFilter<ModelType>] = []) {
    self.url = url
    self.filters = filters
    
    super.init()
  }
  
  public func getResults(config:  AVStockFetcherConfiguration = AVStockFetcherConfiguration(),
                         completion: @escaping ParsedStockCompletion<ModelType>)
  {
    let modelFilters = filters
    AVStockDataFetcher.fetchDataAsync(
      forURL: url,
      withFetchConfig: config,
      completionBlock: { results, error in
        if let results = results, error == nil {
          let parsed = try! ConcurrentParser<ModelType>.parse(
            input: results,
            withFilters: modelFilters,
            config: config)
            .flatMap { $0 }
            .sorted { model1, model2 -> Bool in
              return model1.date < model2.date
          }
          config.callbackQueue.executeCallback { completion(parsed, nil) }
        } else {
          config.callbackQueue.executeCallback { completion(nil, error) }
        }
    })
  }

  
  public func getRawResults(
    config:  AVStockFetcherConfiguration = AVStockFetcherConfiguration(),
    completion: @escaping UnparsedStockCompletion)
  {
    AVStockDataFetcher.fetchDataAsync(
      forURL: url,
      withFetchConfig: config,
      completionBlock: { results, error in
        config.callbackQueue.executeCallback { completion(results, error) }
    })
  }
  
  // MARK - Internal
  
  internal static func fetchDataAsync(forURL url: URL,
                                      withFetchConfig config: AVStockFetcherConfiguration,
                                      completionBlock: @escaping UnparsedStockCompletion)
  {
    config.fetchQueue.async {
      do {
        let timeSeries = try AVStockDataFetcher.fetchData(forURL: url)
        completionBlock(timeSeries, nil)
      } catch {
        completionBlock(nil, error)
      }
    }
  }
  
  // MARK - fileprivate
  
  fileprivate static func flattenResponse(from input: [String: [String: String]]) -> [[String: String]]
  {
    return input.flatMap { (arg) -> [String: String]? in
      var (date, data) = arg
      data["date"] = date
      return data
    }
  }
  
  fileprivate static func transform(fromRaw raw: [String: String],
                                    withFilters modelFilters: [ModelFilter<ModelType>]) throws -> ModelType?
  {
    do {
      let element = try JSONDecoder().decode(ModelType.self, from: JSONSerialization.data(withJSONObject: raw, options: .prettyPrinted))
      
      guard AVStockDataFetcher<ModelType>.evaluateFilterChain(model: element, forFilters: modelFilters) else { return nil }
      return element
    } catch {
      return nil
    }
  }
  
  // MARK - Private
  
  private static func evaluateFilterChain<ModelType>(
    model: ModelType,
    forFilters filters: [ModelFilter<ModelType>]) -> Bool
  {
    for filter in filters {
      guard filter(model) else { return false }
    }
    
    return true
  }
  
  private static func fetchData(forURL url: URL) throws -> UnparsedStockResults {
    let data = try Data.init(contentsOf: url)
    let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: Any]
    
    var dataKey: String? = nil
    for key in json.keys {
      if key != metadataKey {
        dataKey = key
        break
      }
    }
    
    guard let timeSeriesKey = dataKey else {
      throw AVDataFetchingError.timeSeriesKeyMissing
    }
    guard let result = json[timeSeriesKey] as? UnparsedStockResults else {
      throw AVDataFetchingError.noJSONSerialization
    }
    return result
  }
}

// MARK - DispatchQueue extension

extension DispatchQueue {
  fileprivate func executeCallback(_ callback: @escaping () -> ())
  {
    self.async { callback() }
  }
}

// MARK: concurrentMap Array extension

extension Array {
  internal func concurrentMap<B>(failOnParsingError: Bool, _ transform: @escaping (Element) -> B?) -> [B?]
  {
    var result = Array<B?>(repeatElement(nil, count: count))
    let queue = DispatchQueue(label: "serial queue")
    DispatchQueue.concurrentPerform(iterations: count) { idx in
      let element = self[idx]
      let transformed = transform(element)
      
      queue.sync {
        result[idx] = transformed
      }
    }
    
    return result
  }
}

// MARK: Model parsers

internal class ConcurrentParser<Model: Decodable & AVDateOrderable>: StockResultsParser {
  typealias ModelType = Model
  
  internal static func parse(
    input: UnparsedStockResults,
    withFilters modelFilters: [ModelFilter<ModelType>],
    config: AVStockFetcherConfiguration) throws -> [ModelType?]
  {
    let resultArray = AVStockDataFetcher<ModelType>.flattenResponse(from: input)
    
    return resultArray.concurrentMap(failOnParsingError: config.failOnParsingError, { (input) -> ModelType? in
      do {
        return try AVStockDataFetcher<ModelType>.transform(fromRaw: input, withFilters: modelFilters)
      } catch {
        return nil
      }
    })
  }
}

internal class SerialParser<Model: Decodable & AVDateOrderable>: StockResultsParser {
  typealias ModelType = Model
  
  internal static func parse(
    input: UnparsedStockResults,
    withFilters modelFilters: [ModelFilter<ModelType>],
    config: AVStockFetcherConfiguration) throws -> [ModelType?]
  {
    return input.flatMap({ (key, value) in
      var mutableDict = value
      mutableDict["date"] = key
      do {
        return try AVStockDataFetcher<ModelType>.transform(fromRaw: mutableDict, withFilters: modelFilters)
      } catch {
        return nil
      }
    })
  }
}
