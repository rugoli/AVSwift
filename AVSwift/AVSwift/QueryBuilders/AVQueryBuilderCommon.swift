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
  
  var modelFilters: [ModelFilter<ModelType>] { get }
  
  func getResults(config: AVStockFetcherConfiguration, completion: @escaping ([ModelType]?, Error?) -> Void)
  func getRawResults(completion: @escaping (NSDictionary) -> Void)
}

extension AVQueryBuilderProtocol {
  
  private func build(withFilters filters: [ModelFilter<ModelType>]) -> AVStockDataFetcher<ModelType> {
    return AVStockDataFetcher<ModelType>(url: self.buildURL(), filters: filters)
  }
  
  // convenience methods to go straight from the query builder to the results
  public func getResults(config: AVStockFetcherConfiguration = AVStockFetcherConfiguration(), completion: @escaping ParsedStockCompletion<ModelType>) {
    self.build(withFilters: self.modelFilters).getResults(completion: completion, config: config)
  }
  
  public func getRawResults(completion: @escaping (NSDictionary) -> Void) {
    self.build(withFilters: self.modelFilters).getRawResults(completion: completion)
  }
}

