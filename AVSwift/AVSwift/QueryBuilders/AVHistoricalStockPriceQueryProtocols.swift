//
//  AVHistoricalStockPriceQueryProtocols.swift
//  AVSwift
//
//  Created by Roshan Goli on 2/25/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

// MARK: AVHistoricalStockPricesBuilderProtocol

protocol AVHistoricalStockPricesBuilderProtocol : class, AVQueryBuilderBase {
  func setSymbol(_ symbol: String) -> Self
  func setPeriodicity(_ periodicity: AVHistoricalTimeSeriesPeriodicity) -> Self
}

// MARK: AVHistoricalStockPricesFiltering

protocol AVHistoricalStockPricesFiltering: class {
  associatedtype ModelType
  var hasDateFilter: Bool { get set }
  
  func withFilter(_ filter: @escaping ModelFilter<ModelType>) -> Self
  func withDateFilter(_ dateFilter: AVDateFilter<ModelType>) -> Self
}

extension AVHistoricalStockPricesFiltering {
  public func withDateFilter(_ dateFilter: AVDateFilter<ModelType>) -> Self
  {
    hasDateFilter = true
    return withFilter(dateFilter.filter)
  }
}
