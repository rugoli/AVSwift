//
//  AVHistoricalStockPricesQueryBuilder.swift
//  AVSwift
//
//  Created by Roshan on 1/2/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

// MARK: AVHistoricalStockPricesBuilderProtocol

public protocol AVHistoricalStockPricesBuilderProtocol : AVQueryBuilderBase {
  func setSymbol(_ symbol: String) -> Self
  func setPeriodicity(_ periodicity: AVHistoricalTimeSeriesPeriodicity) -> Self
}

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

public class AVHistoricalStandardStockPricesBuilder: AVHistoricalStockPricesQueryBuilderBase {
  
  public init() {
    super.init(withAdjustedPrices: false)
  }
}

extension AVHistoricalStandardStockPricesBuilder: AVQueryBuilderProtocol
{
  typealias ModelType = AVHistoricalStockPriceModel
}

// MARK: AVHistoricalAdjustedStockPricesBuilder

public class AVHistoricalAdjustedStockPricesBuilder: AVHistoricalStockPricesQueryBuilderBase {
  
  public init() {
    super.init(withAdjustedPrices: true)
  }
}

extension AVHistoricalAdjustedStockPricesBuilder: AVQueryBuilderProtocol
{
  typealias ModelType = AVHistoricalAdjustedStockPriceModel
}
