//
//  AVPerformanceTimer.swift
//  AVSwift
//
//  Created by Roshan Goli on 3/3/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

internal class AVPerformanceTimer {
  let startTime: Date
  var endTime: Date!
  init() {
    startTime = Date()
  }
  
  public func stop(_ message: String) {
    let totalTime = self.stop()
    print(message, totalTime)
  }
  
  public func stop() -> TimeInterval {
    return DateInterval(start: startTime, end: Date()).duration
  }
}
