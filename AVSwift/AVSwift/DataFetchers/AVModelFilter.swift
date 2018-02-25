//
//  AVModelFilter.swift
//  AVSwift
//
//  Created by Roshan Goli on 2/24/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

public protocol AVModelFilter {
  func filterStandard(_: AVHistoricalStockPriceModel) -> Bool
  func filterAdjusted(_: AVHistoricalAdjustedStockPriceModel) -> Bool
}

public extension AVModelFilter {
  func filterStandard(_: AVHistoricalStockPriceModel) -> Bool {
    return true
  }
  
  func filterAdjusted(_: AVHistoricalAdjustedStockPriceModel) -> Bool {
    return true
  }
}

public enum AVDateFilter {
  case after(Date)
  case before(Date)
  case between(Date, Date)
}

extension AVDateFilter: AVModelFilter {
  public func filterStandard(_ model: AVHistoricalStockPriceModel) -> Bool {
    switch self {
    case .after(let afterDate):
      return model.date >= afterDate
    case .before(let beforeDate):
      return model.date <= beforeDate
    case .between(let afterDate, let beforeDate):
      return model.date <= beforeDate && model.date >= afterDate
    }
  }
  
  public func filterAdjusted(_ model: AVHistoricalAdjustedStockPriceModel) -> Bool {
    switch self {
    case .after(let afterDate):
      return model.date >= afterDate
    case .before(let beforeDate):
      return model.date <= beforeDate
    case .between(let afterDate, let beforeDate):
      return model.date <= beforeDate && model.date >= afterDate
    }
  }
}
