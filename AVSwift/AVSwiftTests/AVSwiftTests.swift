//
//  AVSwiftTests.swift
//  AVSwiftTests
//
//  Created by Roshan on 1/1/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import XCTest
@testable import AVSwift

class AVSwiftTests: XCTestCase {
  
  override func setUp() {
    AVAPIKeyStore.sharedInstance.setAPIKey(apiKey: "M8N0ZCT3MC1J9XOP")
  }
  
  func testBuilders() {
    let testBuilder = AVHistoricalStandardStockPricesBuilder()
    testBuilder
      .setOutputSize(.full)
      .setSymbol("MSFT")
      .getResults { results, error in
        XCTAssertTrue(error == nil && results != nil)
      }
  }
  
  func testSerial() {
    let queue = DispatchQueue(label: "synchronous")
    var testResults: [String: [String: String]]? = nil
    queue.sync {
      AVHistoricalStandardStockPricesBuilder()
        .setOutputSize(.full)
        .setSymbol("MSFT")
        .getRawResults { results, error in
          testResults = results
        }
      sleep(5)
    }
    XCTAssertNotNil(testResults)
    
    self.measure {
       let _ = AVStockDataFetcher<AVHistoricalStockPriceModel>.serialParsing(
        input: testResults!,
        modelFilters: [(AVHistoricalStockPriceModel) -> Bool]())
    }
  }
}
