//
//  AVQueryBuilderCommon.swift
//  AVSwift
//
//  Created by Roshan on 1/2/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

protocol AVQueryBuilderProtocol: class {
  associatedtype ModelType: Decodable
  
  func buildURL() -> URL
  
  func getResults(completion: ([ModelType]?, Error?) -> Void)
  func getRawResults(completion: (NSDictionary) -> Void)
}

extension AVQueryBuilderProtocol {
  
  private func build() -> AVStockDataFetcher<ModelType> {
    return AVStockDataFetcher<ModelType>(url: self.buildURL())
  }
  
  // convenience methods to go straight from the query builder to the results
  public func getResults(completion: ([ModelType]?, Error?) -> Void) {
    self.build().getResults(completion: completion)
  }
  
  public func getRawResults(completion: (NSDictionary) -> Void) {
    self.build().getRawResults(completion: completion)
  }
}

