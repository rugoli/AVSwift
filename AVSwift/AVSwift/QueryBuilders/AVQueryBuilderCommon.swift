//
//  AVQueryBuilderCommon.swift
//  AVSwift
//
//  Created by Roshan on 1/2/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

protocol AVQueryBuilderProtocol: class {
  associatedtype DataFetcher
  associatedtype Builder: AVQueryBuilder
  
  func build() -> DataFetcher
  func buildURL() -> URL
  
  var outputSize: AVOutputSize {get set}
  var dataOutputType: AVOutputDataType {get set}
  
  func setOuputSize(_ outputSize: AVOutputSize) -> Builder
  func setDataOutputType(_ outputType: AVOutputDataType) -> Builder
}

extension AVQueryBuilderProtocol {
  public func setOuputSize(_ outputSize: AVOutputSize) -> Builder {
    self.outputSize = outputSize
    return self as! Builder
  }
  
  public func setDataOutputType(_ outputType: AVOutputDataType) -> Builder {
    self.dataOutputType = outputType
    return self as! Builder
  }
}
