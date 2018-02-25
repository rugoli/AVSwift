//
//  AVHistoricalTimeSeriesPeriodicity.swift
//  AVSwift
//
//  Created by Roshan Goli on 2/10/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

public enum AVHistoricalTimeSeriesPeriodicity: String {
  case daily = "Daily"
  case weekly = "Weekly"
  case monthly = "Monthly"
  
  static func ordering() -> [AVHistoricalTimeSeriesPeriodicity] {
    return [.daily, .weekly, .monthly]
  }
  
  func standardFunction() -> String {
    switch self {
      case .daily:
        return "TIME_SERIES_DAILY"
      case .weekly:
        return "TIME_SERIES_WEEKLY"
      case .monthly:
        return "TIME_SERIES_MONTHLY"
    }
  }
  
  func adjustedFunction() -> String {
    switch self {
      case .daily:
        return "TIME_SERIES_DAILY_ADJUSTED"
      case .weekly:
        return "TIME_SERIES_WEEKLY_ADJUSTED"
      case .monthly:
        return "TIME_SERIES_MONTHLY_ADJUSTED"
    }
  }
}
