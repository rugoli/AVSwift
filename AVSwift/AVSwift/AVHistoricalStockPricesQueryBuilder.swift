//
//  AVHistoricalStockPricesQueryBuilder.swift
//  AVSwift
//
//  Created by Roshan on 1/2/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

public class AVHistoricalStockPricesQueryBuilder: AVQueryBuilder {
  var symbol: String?
  
  override public init() {
    symbol = nil
    
    super.init()
  }
  
  public func setSymbol(_ symbol: String) -> AVHistoricalStockPricesQueryBuilder {
    self.symbol = symbol
    return self
  }
  
}
