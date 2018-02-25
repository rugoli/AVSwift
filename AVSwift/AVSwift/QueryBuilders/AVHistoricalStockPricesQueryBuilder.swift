//
//  AVHistoricalStockPricesQueryBuilder.swift
//  AVSwift
//
//  Created by Roshan on 1/2/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

// MARK: AVHistoricalStockPricesQueryBuilderBase

public class AVHistoricalStockPricesQueryBuilderBase: AVQueryBuilder {
  fileprivate var symbol: String = ""
  fileprivate var periodicity: AVHistoricalTimeSeriesPeriodicity = .daily
  fileprivate var isAdjusted: Bool = false
  
  fileprivate init(withAdjustedPrices: Bool = false) {
    self.isAdjusted = withAdjustedPrices
    
    super.init()
  }
  
  override public func timeSeriesFunction() -> String {
    return isAdjusted
      ? periodicity.adjustedFunction()
      : periodicity.standardFunction()
  }
  
  open func buildURL() -> URL {
    let urlComponents = super.buildBaseURL()
    
    let symbolItem = URLQueryItem(name: "symbol", value: symbol)
    
    urlComponents.queryItems?.append(symbolItem)
    return urlComponents.url!
  }
  
}

// MARK: AVHistoricalStockPricesBuilderProtocol

extension AVHistoricalStockPricesQueryBuilderBase: AVHistoricalStockPricesBuilderProtocol {
  public func setSymbol(_ symbol: String) -> Self {
    self.symbol = symbol
    return self
  }
  
  public func setPeriodicity(_ periodicity: AVHistoricalTimeSeriesPeriodicity) -> Self {
    self.periodicity = periodicity
    return self
  }
}

// MARK: AVHistoricalStandardStockPricesBuilder

public final class AVHistoricalStandardStockPricesBuilder: AVHistoricalStockPricesQueryBuilderBase {
  
  public typealias ModelType = AVHistoricalStockPriceModel
  internal var modelFilters: [ModelFilter<ModelType>] = []
  
  public init() {
    super.init(withAdjustedPrices: false)
  }
}

extension AVHistoricalStandardStockPricesBuilder: AVHistoricalStockPricesFiltering {
  public func withFilter(_ filter: @escaping ModelFilter<ModelType>) -> Self {
    modelFilters.append(filter)
    return self
  }
}

extension AVHistoricalStandardStockPricesBuilder: AVQueryBuilderProtocol {}

// MARK: AVHistoricalAdjustedStockPricesBuilder

public final class AVHistoricalAdjustedStockPricesBuilder: AVHistoricalStockPricesQueryBuilderBase {
  
  public typealias ModelType = AVHistoricalAdjustedStockPriceModel
  internal var modelFilters: [ModelFilter<ModelType>] = []
  
  public init() {
    super.init(withAdjustedPrices: true)
  }
}

extension AVHistoricalAdjustedStockPricesBuilder: AVHistoricalStockPricesFiltering {
  
  public func withFilter(_ filter: @escaping ModelFilter<ModelType>) -> Self {
    modelFilters.append(filter)
    return self
  }
  
}
extension AVHistoricalAdjustedStockPricesBuilder: AVQueryBuilderProtocol {}
