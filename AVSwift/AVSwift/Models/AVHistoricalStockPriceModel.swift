//
//  AVHistoricalStockPriceModel.swift
//  AVSwift
//
//  Created by Roshan on 1/7/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

enum ModelError: Error {
  case parsingError(error: String)
}

public final class AVHistoricalStockPriceModel: NSObject {
  let date: String
  let open: String
  let high: String
  let low: String
  let close: String
  let volume: String
  
  required public init(date: String,
                open: String,
                high: String,
                low: String,
                close: String,
                volume: String) {
    self.date = date
    self.open = open
    self.high = high
    self.low = low
    self.close = close
    self.volume = volume
    
    super.init()
  }
}

extension AVHistoricalStockPriceModel: Decodable {
  enum AVHistoricalStockPriceModelKeys: String, CodingKey {
    case date = "date"
    case open = "1. open"
    case high = "2. high"
    case low = "3. low"
    case close = "4. close"
    case volume = "5. volume"
  }
  
  public convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: AVHistoricalStockPriceModelKeys.self) // defining our (keyed) container
    do {
      let date: String = try container.decode(String.self, forKey: .date)
      let open: String = try container.decode(String.self, forKey: .open)
      let high: String = try container.decode(String.self, forKey: .high)
      let low: String = try container.decode(String.self, forKey: .low)
      let close: String = try container.decode(String.self, forKey: .close)
      let volume: String = try container.decode(String.self, forKey: .volume)
      self.init(date: date, open: open, high: high, low: low, close: close, volume: volume)
    } catch {
      throw ModelError.parsingError(error: error.localizedDescription)
    }
  }
}
