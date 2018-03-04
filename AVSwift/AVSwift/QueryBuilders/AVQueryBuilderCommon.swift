//
//  AVQueryBuilderCommon.swift
//  AVSwift
//
//  Created by Roshan on 1/2/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

protocol AVQueryBuilderProtocol: class {
  associatedtype ModelType: Decodable, AVDateOrderable
  
  func buildURL() -> URL
  
  var modelFilters: [ModelFilter<ModelType>] { get }
  
  func getResults(
    config: AVStockFetcherConfiguration,
    completion: @escaping ParsedStockCompletion<ModelType>)
  func getRawResults(
    config: AVStockFetcherConfiguration,
    completion: @escaping ([String: [String: String]]?, Error?) -> Void)
}

extension AVQueryBuilderProtocol {
  
  private func build(withFilters filters: [ModelFilter<ModelType>]) -> AVStockDataFetcher<ModelType> {
    return AVStockDataFetcher<ModelType>(url: self.buildURL(), filters: filters)
  }
  
  // convenience methods to go straight from the query builder to the results
  public func getResults(
    config: AVStockFetcherConfiguration = AVStockFetcherConfiguration(),
    completion: @escaping ParsedStockCompletion<ModelType>)
  {
    self.build(withFilters: self.modelFilters).getResults(config: config, completion: completion)
  }
  
  public func getRawResults(
    config: AVStockFetcherConfiguration = AVStockFetcherConfiguration(),
    completion: @escaping UnparsedStockCompletion)
  {
    self.build(withFilters: self.modelFilters).getRawResults(config: config, completion: completion)
  }
}

