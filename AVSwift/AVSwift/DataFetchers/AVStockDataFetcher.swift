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

public class AVStockDataFetcher<ModelType: Decodable>: NSObject {
  let url: URL
  
  public init(url: URL) {
    self.url = url
    
    super.init()
  }
  
  public func getResults(completion: ([ModelType]?, Error?) -> Void) {
    do {
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
        return
      }
      let timeSeries: [String: [String: String]] = json[timeSeriesKey]! as! [String : [String: String]]
      let parsed: [ModelType] = timeSeries.flatMap({ key, value in
        var mutableDict = value
        mutableDict["date"] = key
        do {
          let element = try JSONDecoder().decode(ModelType.self, from: JSONSerialization.data(withJSONObject: mutableDict, options: .prettyPrinted))
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
  
  public func getRawResults(completion: (NSDictionary) -> Void) {
    // no-op
  }
}
