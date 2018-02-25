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

public class AVStockDataFetcher<ModelType: Decodable>: NSObject {
  let url: URL
  let filters: [ModelFilter<ModelType>]
  
  public init(url: URL, filters: [ModelFilter<ModelType>] = []) {
    self.url = url
    self.filters = filters
    
    super.init()
  }
  
  public func getResults(completion: @escaping ([ModelType]?, Error?) -> Void) {
    let url = self.url
    let modelFilters = self.filters
    DispatchQueue.global(qos: .userInitiated).async {
      do {
        let timeSeries = try AVStockDataFetcher.fetchData(forURL: url)
        let parsed: [ModelType]? = timeSeries.flatMap({ (key, value) in
          var mutableDict = value
          mutableDict["date"] = key
          do {
            let element = try JSONDecoder().decode(ModelType.self, from: JSONSerialization.data(withJSONObject: mutableDict, options: .prettyPrinted))
            guard AVStockDataFetcher.evaluateFilterChain(model: element, forFilters: modelFilters) else { return nil }
            return element
          } catch {
            completion(nil, error)
          }
          return nil
        })
        completion(parsed, nil)
      } catch {
        completion(nil, error)
      }
    }
  }
  
  public func getRawResults(completion: (NSDictionary) -> Void) {
    // no-op
  }
  
  // MARK - Private
  
  private static func evaluateFilterChain(model: ModelType, forFilters filters: [ModelFilter<ModelType>]) -> Bool {
    for filter in filters {
      guard filter(model) else { return false }
    }
    
    return true
  }
  
  private static func fetchData(forURL url: URL) throws -> [String: [String: String]] {
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
    guard let result = json[timeSeriesKey] as? [String : [String: String]] else {
      throw AVDataFetchingError.noJSONSerialization
    }
    return result
  }
}
