//
//  AVModelParsingError.swift
//  AVSwift
//
//  Created by Roshan Goli on 2/10/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

public enum AVModelError: Error {
  // Model parsing
  case parsingError(error: String)
}

public enum AVDataFetchingError: Error {
  case timeSeriesKeyMissing
  case noJSONSerialization
}
