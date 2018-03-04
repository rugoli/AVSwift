//
//  AVDateFormatter.swift
//  AVSwift
//
//  Created by Roshan Goli on 2/1/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

fileprivate let sharedDateFormatter = AVDateFormatter.dateFormatter()

fileprivate class AVDateFormatter {
  
  fileprivate static func dateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter
  }
  
  fileprivate static var shared: DateFormatter {
    get {
      return sharedDateFormatter
    }
  }
}

public enum AVDateFormatterError: Error {
  case invalidString(String)
}

extension String {
  func toDate() throws -> Date {
    let formatter = AVDateFormatter.shared
    guard let date = formatter.date(from: self) else {
      throw AVDateFormatterError.invalidString("Invalid date string: \(self)")
    }
    return date
  }
}

extension Date {
  static func from(month: Int, day: Int, year: Int, withFallback fallback: Date? = nil) throws -> Date {
    let monthFormat = String(format: "%02d", month)
    let dayFormat = String(format: "%02d", day)
    do {
      let date = try "\(year)-\(monthFormat)-\(dayFormat)".toDate()
      return date
    } catch {
      guard let fallback = fallback else {
        throw error
      }
      return fallback
    }
  }
}
