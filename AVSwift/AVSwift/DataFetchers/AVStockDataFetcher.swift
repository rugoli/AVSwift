//
//  AVStockDataFetcher.swift
//  AVSwift
//
//  Created by Roshan on 1/2/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

public class AVStockDataFetcher: NSObject {
  let url: NSURL
  
  public required init(url: NSURL) {
    self.url = url
    
    super.init()
  }
}
