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

public class AVHistoricalStockPricesQueryBuilder<PriceType: NSObject & Decodable>: AVQueryBuilder {
  var symbol: String?
  
  override fileprivate init() {
    symbol = nil
    
    super.init()
  }
  
  public func setSymbol(_ symbol: String) -> AVHistoricalStockPricesQueryBuilder {
    self.symbol = symbol
    return self
  }
  
}

extension AVHistoricalStockPricesQueryBuilder: AVQueryBuilderProtocol {
  typealias ModelType = PriceType
  
  public func build() -> AVStockDataFetcher<PriceType> {
    return AVStockDataFetcher<PriceType>(url: self.buildURL())
  }
  
  public func buildURL() -> URL {
    let url = super.buildBaseURL()
    return url
  }
}
