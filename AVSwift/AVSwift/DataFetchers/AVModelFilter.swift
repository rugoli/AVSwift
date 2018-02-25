//
//  AVModelFilter.swift
//  AVSwift
//
//  Created by Roshan Goli on 2/24/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

public enum AVDateFilter<T> {
  case after(Date)
  case before(Date)
  case between(Date, Date)
  
  public func filter(_ model: T) -> Bool
  {
    switch model.self {
    case is AVHistoricalStockPriceModel:
      return filterStandard(model as! AVHistoricalStockPriceModel)
    case is AVHistoricalAdjustedStockPriceModel :
      return filterAdjusted(model as! AVHistoricalAdjustedStockPriceModel)
    default:
      return false
    }
  }
  
  private func filterStandard(_ model: AVHistoricalStockPriceModel) -> Bool
  {
    switch self {
    case .after(let afterDate):
      return model.date >= afterDate
    case .before(let beforeDate):
      return model.date <= beforeDate
    case .between(let afterDate, let beforeDate):
      return model.date <= beforeDate && model.date >= afterDate
    }
  }
  
  private func filterAdjusted(_ model: AVHistoricalAdjustedStockPriceModel) -> Bool
  {
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
