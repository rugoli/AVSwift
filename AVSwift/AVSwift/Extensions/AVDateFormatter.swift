//
//  AVDateFormatter.swift
//  AVSwift
//
//  Created by Roshan Goli on 2/1/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

enum AVDateFormatterError: Error {
  case invalidString(String)
}

extension String {
  func toDate() throws -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    guard let date = formatter.date(from: self) else {
      throw AVDateFormatterError.invalidString("Invalid date string: \(self)")
    }
    return date
  }
}
