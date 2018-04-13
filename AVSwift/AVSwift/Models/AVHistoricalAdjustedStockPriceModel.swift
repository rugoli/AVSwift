//
//  AVHistoricalAdjustedStockPriceModel.swift
//  AVSwift
//
//  Created by Roshan on 1/7/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

public final class AVHistoricalAdjustedStockPriceModel: CustomStringConvertible, AVObjectDescription {
  public let date: Date
  public let open: Float
  public let high: Float
  public let low: Float
  public let close: Float
  public let adjustedClose: Float
  public let volume: Int
  public let dividend: Float
  public let splitCoefficient: Float?
  
  required public init(date: Date,
                open: Float,
                high: Float,
                low: Float,
                close: Float,
                adjustedClose: Float,
                volume: Int,
                dividend: Float,
                splitCoefficient: Float?) {
    self.date = date
    self.open = open
    self.high = high
    self.low = low
    self.close = close
    self.adjustedClose = adjustedClose
    self.volume = volume
    self.dividend = dividend
    self.splitCoefficient = splitCoefficient
  }
  
  public var description: String {
    return self.description(for: self)
  }
}

extension AVHistoricalAdjustedStockPriceModel: Decodable {
  enum AVHistoricalAdjustedStockPriceModelKeys: String, CodingKey {
    case date = "date"
    case open = "1. open"
    case high = "2. high"
    case low = "3. low"
    case close = "4. close"
    case adjustedClose = "5. adjusted close"
    case volume = "6. volume"
    case dividend = "7. dividend amount"
    case splitCoefficient = "8. split coefficient"
  }
  
  public convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: AVHistoricalAdjustedStockPriceModelKeys.self) // defining our (keyed) container
    do {
      let dateString: String = try container.decode(String.self, forKey: .date)
      let date = try dateString.toDate()
      let open: String = try container.decode(String.self, forKey: .open)
      let high: String = try container.decode(String.self, forKey: .high)
      let low: String = try container.decode(String.self, forKey: .low)
      let close: String = try container.decode(String.self, forKey: .close)
      let adjustedClose: String = try container.decode(String.self, forKey: .adjustedClose)
      let volume: String = try container.decode(String.self, forKey: .volume)
      let dividend: String = try container.decode(String.self, forKey: .dividend)
      let splitCoeff: String? = try? container.decode(String.self, forKey: .splitCoefficient)
      self.init(
        date: date,
        open: Float(open)!,
        high: Float(high)!,
        low: Float(low)! ,
        close: Float(close)!,
        adjustedClose: Float(adjustedClose)!,
        volume: Int(volume)!,
        dividend: Float(dividend)!,
        splitCoefficient: splitCoeff != nil ? Float(splitCoeff!)! : nil)
    } catch {
      throw AVModelError.parsingError(error: error.localizedDescription)
    }
  }
}

extension AVHistoricalAdjustedStockPriceModel: AVDateOrderable {}

extension AVHistoricalAdjustedStockPriceModel: Equatable {
  public static func == (lhs: AVHistoricalAdjustedStockPriceModel, rhs: AVHistoricalAdjustedStockPriceModel) -> Bool {
    return lhs.date == rhs.date
      && lhs.open == rhs.open
      && lhs.high == rhs.high
      && lhs.low == rhs.low
      && lhs.close == rhs.close
      && lhs.adjustedClose == rhs.adjustedClose
      && lhs.volume == rhs.volume
      && lhs.dividend == rhs.dividend
      && lhs.splitCoefficient == rhs.splitCoefficient
  }
  
  
}
