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

public protocol AVQueryBuilderBase {
  func setOutputSize(_ outputSize: AVOutputSize) -> Self
}

public class AVQueryBuilder: NSObject {
  open var outputSize: AVOutputSize
  
  override init() {
    outputSize = .compact
    
    super.init()
  }
  
  open func buildBaseURL() -> NSURLComponents {
    let urlComponents = NSURLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "www.alphavantage.co"
    urlComponents.path = "/query"
    
    let outputSizeItem = URLQueryItem(name: "outputsize", value: self.outputSize.rawValue)
    let dataTypeItem = URLQueryItem(name: "datatype", value: "json")
    let apiKeyItem = URLQueryItem(name: "apikey", value: AVAPIKeyStore.sharedInstance.apiKey)
    urlComponents.queryItems = [outputSizeItem, dataTypeItem, apiKeyItem]
    
    return urlComponents
  }
  
  public func setOutputSize(_ outputSize: AVOutputSize) -> Self {
    self.outputSize = outputSize
    return self
  }
}
