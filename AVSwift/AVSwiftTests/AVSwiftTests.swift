//
//  AVSwiftTests.swift
//  AVSwiftTests
//
//  Created by Roshan on 1/1/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import XCTest
@testable import AVSwift

let startDate = try! Date.from(month: 7, day: 1, year: 2015)
let endDate = try! Date.from(month: 9, day: 30, year: 2016)

class AVSwiftTests: XCTestCase {
  
  override func setUp() {
    AVAPIKeyStore.sharedInstance.setAPIKey(apiKey: "")
  }
  
  func testBuilders() {
    let testBuilder = AVHistoricalStandardStockPricesBuilder()
    testBuilder
      .setOutputSize(.full)
      .setSymbol("MSFT")
      .withDateFilter(AVDateFilter.after(startDate))
      .getResults { results, error in
        XCTAssertTrue(error == nil && results != nil)
      }
  }
  
  func testSerialParsing() {
    let queue = DispatchQueue(label: "synchronous")
    var testResults: [String: [String: String]]? = nil
    queue.sync {
      AVHistoricalStandardStockPricesBuilder()
        .setOutputSize(.full)
        .setSymbol("MSFT")
        .withDateFilter(AVDateFilter.between(startDate, endDate))
        .getRawResults { results, error in
          testResults = results
          print(error)
        }
      sleep(5)
    }
    XCTAssertNotNil(testResults)
    
    self.measure {
       let _ = AVStockDataFetcher<AVHistoricalStockPriceModel>.serialParsing(
        input: testResults!,
        withFilters: [],
        config: AVStockFetcherConfiguration())
    }
  }
  
  func testConcurrentParsing() {
    let queue = DispatchQueue(label: "synchronous")
    var testResults: [String: [String: String]]? = nil
    queue.sync {
      AVHistoricalStandardStockPricesBuilder()
        .setOutputSize(.full)
        .withDateFilter(AVDateFilter.between(startDate, endDate))
        .setSymbol("MSFT")
        .getRawResults { results, error in
          testResults = results
        }
      sleep(5)
    }
    XCTAssertNotNil(testResults)
    
    self.measure {
      let _ = try! ConcurrentParser<AVHistoricalStockPriceModel>.parse(
        input: testResults!,
        withFilters: [],
        config: AVStockFetcherConfiguration())
    }
  }
  
  func testBetweenDateFilters()
  {
    let queue = DispatchQueue(label: "myQueue")
    var testResults: [AVHistoricalStockPriceModel]? = nil
    
    queue.sync {
      AVHistoricalStandardStockPricesBuilder()
        .setOutputSize(.full)
        .withDateFilter(AVDateFilter.between(startDate, endDate))
        .setSymbol("MSFT")
        .getResults { results, error in
          testResults = results
        }
      sleep(5)
    }
    XCTAssertNotNil(testResults)
    
    let filtered = testResults?.filter {
      $0.date < startDate || $0.date > endDate
    }
    XCTAssertTrue(filtered?.count == 0)
  }
  
  func testCustomFilters()
  {
    let queue = DispatchQueue(label: "myQueue")
    var testResults: [AVHistoricalStockPriceModel]? = nil
    
    queue.sync {
      AVHistoricalStandardStockPricesBuilder()
        .setOutputSize(.full)
        .withFilter({ model in
          return model.close < model.open
        })
        .setSymbol("MSFT")
        .getResults { results, error in
          testResults = results
        }
      sleep(5)
    }
    XCTAssertNotNil(testResults)
    
    let filtered = testResults?.filter {
      $0.open <= $0.close
    }
    XCTAssertTrue(filtered?.count == 0)
  }
}
