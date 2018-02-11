//
//  AVHistoricalStockPricesQueryBuilder.swift
//  AVSwift
//
//  Created by Roshan on 1/2/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

public func AVHistoricalStockPricesBuilder() -> AVHistoricalStockPricesQueryBuilder<AVHistoricalAdjustedStockPriceModel> {
  return AVHistoricalStockPricesQueryBuilder<AVHistoricalAdjustedStockPriceModel>()
}

public class AVHistoricalStockPricesQueryBuilder<PriceType: Decodable>: AVQueryBuilder {
  fileprivate var symbol: String = ""
  fileprivate var periodicity: AVHistoricalTimeSeriesPeriodicity = .daily
  fileprivate var isAdjusted: Bool = true
  
  override fileprivate init() {
    super.init()
  }
  
  public func setSymbol(_ symbol: String) -> Self {
    self.symbol = symbol
    return self
  }
  
  public func setPeriodicity(_ periodicity: AVHistoricalTimeSeriesPeriodicity) -> Self {
    self.periodicity = periodicity
    return self
  }
  
  override public func timeSeriesFunction() -> String {
    return isAdjusted
      ? periodicity.adjustedFunction()
      : periodicity.standardFunction()
  }
  
  public func withAdjustedPrices() -> AVHistoricalStockPricesQueryBuilder<AVHistoricalAdjustedStockPriceModel> {
    let adjustedQuery: AVHistoricalStockPricesQueryBuilder<AVHistoricalAdjustedStockPriceModel> = self.copy()
    adjustedQuery.isAdjusted = true
    return adjustedQuery
  }
  
}

extension AVHistoricalStockPricesQueryBuilder: AVQueryBuilderProtocol {
  typealias ModelType = PriceType
  
  internal func buildURL() -> URL {
    let urlComponents = super.buildBaseURL()
    
    let symbolItem = URLQueryItem(name: "symbol", value: symbol)
    
    urlComponents.queryItems?.append(symbolItem)
    return urlComponents.url!
  }
}

// MARK - Copying

extension AVHistoricalStockPricesQueryBuilder {
  private func copy<NewType: Decodable>() -> AVHistoricalStockPricesQueryBuilder<NewType> {
    let newBuilder = AVHistoricalStockPricesQueryBuilder<NewType>()
    newBuilder.isAdjusted = isAdjusted
    newBuilder.symbol = symbol
    newBuilder.periodicity = periodicity
    newBuilder.outputSize = outputSize
    return newBuilder
  }
}
