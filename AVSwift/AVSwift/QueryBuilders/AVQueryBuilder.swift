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

public class AVQueryBuilder: NSObject {
  var outputSize: AVOutputSize
  
  override init() {
    outputSize = .compact
    
    super.init()
  }
  
  public func buildBaseURL() -> URL {
    return URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=MSFT&outputsize=full&apikey=demo")!
//    return URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&outputsize=\(self.outputSize.rawValue)&datatype=json")!
  }
  
  public func setOuputSize(_ outputSize: AVOutputSize) -> Self {
    self.outputSize = outputSize
    return self
  }
}
