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
  
  public func setOuputSize<Builder: AVQueryBuilder>(_ outputSize: AVOutputSize) -> Builder {
    self.outputSize = outputSize
    return self as! Builder
  }
  
  public func setDataOutputType<Builder: AVQueryBuilder>(_ outputType: AVOutputDataType) -> Builder {
    self.dataOutputType = outputType
    return self as! Builder
  }
}
