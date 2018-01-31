//
//  AVAPIKeyStore.swift
//  AVSwift
//
//  Created by Roshan Goli on 1/30/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

private let shared = AVAPIKeyStore()

final class AVAPIKeyStore: NSObject {
  public var apiKey: String = ""
  
  public class var sharedInstance: AVAPIKeyStore {
    return shared
  }
  
  public func setAPIKey(apiKey: String) {
    self.apiKey = apiKey
  }

}
