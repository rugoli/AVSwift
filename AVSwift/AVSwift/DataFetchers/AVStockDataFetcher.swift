//
//  AVStockDataFetcher.swift
//  AVSwift
//
//  Created by Roshan on 1/2/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit
import Foundation

fileprivate let metadataKey: String = "Metadata"
public typealias ModelFilter<T> = (T) -> Bool
public typealias ParsedStockCompletion<M> = (AVStockResults<M>?, Error?) -> Void
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

internal enum StockTransformationResult<T: Decodable & AVDateOrderable> {
  case parseError
  case result(T)
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
          let parsed = ConcurrentParser<ModelType>.parseAndFilter(
            input: results,
            withFilters: modelFilters,
            config: config)
          if config.failOnParsingError {
            config.callbackQueue.executeCallback { completion(nil, AVModelError.parsingError(error: "Test")) }
          } else {
            let stockResults = AVStockDataFetcher<ModelType>.constructStockResults(fromResults: parsed)
            config.callbackQueue.executeCallback { completion(stockResults, nil) }
          }
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
    return input.compactMap { (arg) -> [String: String]? in
      var (date, data) = arg
      data["date"] = date
      return data
    }
  }
  
  internal static func transform(fromRaw raw: [String: String],
                                 withFilters modelFilters: [ModelFilter<ModelType>]) -> StockTransformationResult<ModelType>?
  {
    do {
      let element = try JSONDecoder().decode(ModelType.self, from: JSONSerialization.data(withJSONObject: raw, options: .prettyPrinted))
      
      guard AVStockDataFetcher<ModelType>.evaluateFilterChain(model: element, forFilters: modelFilters) else { return nil }
      return .result(element)
    } catch {
      return .parseError
    }
  }
  
  // MARK - Private
  
  private static func constructStockResults(fromResults results: [StockTransformationResult<ModelType>]) -> AVStockResults<ModelType>
  {
    let initialCount = results.count
    let seriesWithoutErrors = AVStockDataFetcher<ModelType>.unwrappedStockResults(wrappedResults: results)
      .sorted { model1, model2 -> Bool in
        return model1.date < model2.date
      }
    let finalCount = seriesWithoutErrors.count
    
    let metadata = AVStockResultsMetadata(
      earliestDate: seriesWithoutErrors.first?.date,
      latestDate: seriesWithoutErrors.last?.date,
      numberOfParsingErrors: initialCount - finalCount)
    return AVStockResults<ModelType>(timeSeries: seriesWithoutErrors, metadata: metadata)
  }
  
  private static func unwrappedStockResults(wrappedResults: [StockTransformationResult<ModelType>]) -> [ModelType] {
    return wrappedResults.compactMap { element in
      switch element {
      case .result(let result):
        return result
      default:
        return nil
      }
    }
  }
  
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
  internal func concurrentMap<B>(transform: @escaping (Element) -> StockTransformationResult<B>?) -> [StockTransformationResult<B>]
  {
    var result = Array<StockTransformationResult<B>?>(repeatElement(nil, count: self.count))
    let queue = DispatchQueue(label: "concurrent queue")
    DispatchQueue.concurrentPerform(iterations: count) { idx in
      let element = self[idx]
      let transformed = transform(element)
      
      queue.sync {
        result[idx] = transformed
      }
    }
    
    return result.compactMap { $0 }
  }
}

// MARK: Model parsers

internal protocol StockResultsParser {
  associatedtype ModelType: Decodable, AVDateOrderable
  static func parseAndFilter(
    input: UnparsedStockResults,
    withFilters modelFilters: [ModelFilter<ModelType>],
    config: AVStockFetcherConfiguration) -> [StockTransformationResult<ModelType>]
}

internal class ConcurrentParser<Model: Decodable & AVDateOrderable>: StockResultsParser {
  typealias ModelType = Model
  
  internal static func parseAndFilter(
    input: UnparsedStockResults,
    withFilters modelFilters: [ModelFilter<ModelType>],
    config: AVStockFetcherConfiguration) -> [StockTransformationResult<ModelType>]
  {
    let resultArray = AVStockDataFetcher<ModelType>.flattenResponse(from: input)
    
    return resultArray.concurrentMap { input -> StockTransformationResult<ModelType>? in
      return AVStockDataFetcher<ModelType>.transform(fromRaw: input, withFilters: modelFilters)
    }
  }
}

internal class SerialParser<Model: Decodable & AVDateOrderable>: StockResultsParser {
  typealias ModelType = Model
  
  internal static func parseAndFilter(
    input: UnparsedStockResults,
    withFilters modelFilters: [ModelFilter<ModelType>],
    config: AVStockFetcherConfiguration) -> [StockTransformationResult<ModelType>]
  {
    return input.compactMap ({ (arg) in
      let (key, value) = arg
      
      var mutableDict = value
      mutableDict["date"] = key
      
      return AVStockDataFetcher<ModelType>.transform(fromRaw: mutableDict, withFilters: modelFilters)
    })
  }
}
