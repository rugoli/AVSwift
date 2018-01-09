//
//  AVQueryBuilderCommon.swift
//  AVSwift
//
//  Created by Roshan on 1/2/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

protocol AVQueryBuilderProtocol: class {
  associatedtype ModelType: NSObject, Decodable
  
  func build() -> AVStockDataFetcher<ModelType>
  func buildURL() -> URL
}

