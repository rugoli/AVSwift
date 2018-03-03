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
public typealias ParsedStockCompletion<M> = ([M]?, Error?) -> Void
public typealias UnparsedStockResults = [String: [String: String]]
public typealias UnparsedStockCompletion = (UnparsedStockResults?, Error?) -> Void


public struct AVStockFetcherConfiguration {
  let fetchQueue: DispatchQueue
  let callbackQueue: DispatchQueue
  
  public init(fetchQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated),
              callbackQueue: DispatchQueue = DispatchQueue.main) {
    self.fetchQueue = fetchQueue
    self.callbackQueue = callbackQueue
  }
}

public class AVStockDataFetcher<ModelType: Decodable & AVDateOrderable>: NSObject {
  let url: URL
  let filters: [ModelFilter<ModelType>]?
  
  public init(url: URL, filters: [ModelFilter<ModelType>]? = nil) {
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
          let parsed = AVStockDataFetcher.serialParsing(
            input: results,
            modelFilters: modelFilters,
            config: config)
            .flatMap{ $0 }
            .sorted { model1, model2 -> Bool in
              return model1.date < model2.date
          }
          config.callbackQueue.executeCallback { completion(parsed, nil) }
        } else {
          completion(nil, error)
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
      completionBlock: completion)
  }
  
  // MARK - Private
  
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
  
  internal func concurrentParsing(input: UnparsedStockCompletion, callback: ([ModelType]?, Error) -> Void) {
    
  }
  
  internal static func serialParsing(
    input: UnparsedStockResults,
    modelFilters: [ModelFilter<ModelType>]?,
    config: AVStockFetcherConfiguration = AVStockFetcherConfiguration()) -> [ModelType?]
  {
    return input.flatMap({ (key, value) in
      var mutableDict = value
      mutableDict["date"] = key
      do {
        let element = try JSONDecoder().decode(ModelType.self, from: JSONSerialization.data(withJSONObject: mutableDict, options: .prettyPrinted))
        guard AVStockDataFetcher.evaluateFilterChain(model: element, forFilters: modelFilters) else { return nil }
        return element
      } catch {
        return nil
      }
    })
  }
  
  
  internal static func evaluateFilterChain<ModelType>(model: ModelType, forFilters filters: [ModelFilter<ModelType>]?) -> Bool {
    guard let filters = filters else { return true }
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

extension DispatchQueue {
  fileprivate func executeCallback(_ callback: @escaping () -> ())
  {
    self.async { callback() }
  }
}
