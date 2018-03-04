//
//  AVStockResults.swift
//  AVSwift
//
//  Created by Roshan Goli on 3/4/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

public final class AVStockResultsMetadata {
  let earliestDate: Date?
  let latestDate: Date?
//  let lastRefreshedDate: Date
  let numberOfParsingErrors: Int
  
  init(earliestDate: Date?,
       latestDate: Date?,
//       lastRefreshedDate: Date,
       numberOfParsingErrors: Int) {
    self.earliestDate = earliestDate
    self.latestDate = latestDate
//    self.lastRefreshedDate = lastRefreshedDate
    self.numberOfParsingErrors = numberOfParsingErrors
  }
}

public final class AVStockResults<Model>{
  let timeSeries: [Model]
  let metadata: AVStockResultsMetadata
  
  init(timeSeries: [Model],
       metadata: AVStockResultsMetadata) {
    self.timeSeries = timeSeries
    self.metadata = metadata
  }
}
