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
    AVAPIKeyStore.sharedInstance.setAPIKey(apiKey: "demo")
  }
  
  func testBuilders() {
    let testBuilder = AVHistoricalStandardStockPricesBuilder()
    testBuilder
      .setOuputSize(.full)
      .setSymbol("MSFT")
      .getResults { results, error in
        XCTAssertTrue(error == nil && results != nil)
      }
  }
}
