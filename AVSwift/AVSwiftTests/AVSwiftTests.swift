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
    let testBuilder = AVHistoricalStockPricesQueryBuilder.builder()
    let fetcher = testBuilder
      .setOuputSize(.full)
      .setSymbol("MSFT")
      .build()
    fetcher.getResults { results in
      print(results)
    }
    XCTAssertNotNil(testBuilder)
    XCTAssertNotNil(fetcher)
  }
}
