//
//  AVHistoricalStockPricesQueryBuilder.swift
//  AVSwift
//
//  Created by Roshan on 1/2/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

public class AVHistoricalStockPricesQueryBuilder<PriceType: NSObject>: AVQueryBuilder {
  public typealias Normal = AVHistoricalStockPriceModel
  var symbol: String?
  
  public class func builder() -> AVHistoricalStockPricesQueryBuilder<Normal> {
    return AVHistoricalStockPricesQueryBuilder<Normal>()
  }
  
  override public init() {
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
