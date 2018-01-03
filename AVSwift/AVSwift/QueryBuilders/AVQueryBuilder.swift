//
//  AVQueryBuilder.swift
//  AVSwift
//
//  Created by Roshan on 1/2/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

public enum AVOutputSize: String {
  case compact = "compact"
  case full = "full"
}

public enum AVOutputDataType {
  case raw, parsed
}

public class AVQueryBuilder: NSObject {
  var outputSize: AVOutputSize
  var dataOutputType: AVOutputDataType
  
  override init() {
    outputSize = .compact
    dataOutputType = .parsed
    
    super.init()
  }
  
  public func buildBaseURL() -> URL {
    return URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&outputsize=\(self.outputSize.rawValue)&datatype=json")!
  }
}
