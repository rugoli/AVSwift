//
//  AVHistoricalStockPricesQueryBuilder.swift
//  AVSwift
//
//  Created by Roshan on 1/2/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

public func AVHistoricalStockPricesBuilder() -> AVHistoricalStockPricesQueryBuilder<AVHistoricalStockPriceModel> {
  return AVHistoricalStockPricesQueryBuilder<AVHistoricalStockPriceModel>()
}

public class AVHistoricalStockPricesQueryBuilder<PriceType: Decodable>: AVQueryBuilder {
  var symbol: String = ""
  var periodicity: AVHistoricalTimeSeriesPeriodicity = .daily
  
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
    return self.periodicity.standardFunction()
  }
  
}

extension AVHistoricalStockPricesQueryBuilder: AVQueryBuilderProtocol {
  typealias ModelType = PriceType
  
  public func build() -> AVStockDataFetcher<PriceType> {
    return AVStockDataFetcher<PriceType>(url: self.buildURL())
  }
  
  internal func buildURL() -> URL {
    let urlComponents = super.buildBaseURL()
    
    let symbolItem = URLQueryItem(name: "symbol", value: symbol)
    
    urlComponents.queryItems?.append(symbolItem)
    return urlComponents.url!
  }
}
