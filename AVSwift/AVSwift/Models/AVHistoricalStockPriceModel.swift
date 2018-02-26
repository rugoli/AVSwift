//
//  AVHistoricalStockPriceModel.swift
//  AVSwift
//
//  Created by Roshan on 1/7/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

public final class AVHistoricalStockPriceModel: CustomStringConvertible, AVObjectDescription {
  public let date: Date
  public let open: Float
  public let high: Float
  public let low: Float
  public let close: Float
  public let volume: Int
  
  required public init(date: Date,
                open: Float,
                high: Float,
                low: Float,
                close: Float,
                volume: Int) {
    self.date = date
    self.open = open
    self.high = high
    self.low = low
    self.close = close
    self.volume = volume
  }
  
  public var description: String {
    return self.description(for: self)
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
      let dateString: String = try container.decode(String.self, forKey: .date)
      let date = try dateString.toDate()
      let open: String = try container.decode(String.self, forKey: .open)
      let high: String = try container.decode(String.self, forKey: .high)
      let low: String = try container.decode(String.self, forKey: .low)
      let close: String = try container.decode(String.self, forKey: .close)
      let volume: String = try container.decode(String.self, forKey: .volume)
      self.init(date: date, open: Float(open)!, high: Float(high)!, low: Float(low)! , close: Float(close)!, volume: Int(volume)!)
    } catch {
      throw AVModelError.parsingError(error: error.localizedDescription)
    }
  }
}

extension AVHistoricalStockPriceModel: AVDateOrderable {}
