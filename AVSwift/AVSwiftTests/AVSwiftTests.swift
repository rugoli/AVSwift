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
    // no-op
  }
  
  func testBuilders() {
    let testBuilder = AVHistoricalStockPricesQueryBuilder()
      .setSymbol("MSFT")
      .setOuputSize(.full)
    XCTAssertNotNil(testBuilder)
  }
}
