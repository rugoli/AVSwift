//
//  ViewController.swift
//  AVTestApp
//
//  Created by Roshan on 1/1/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  private lazy var registrar = AVAPIKeyRegistrar()
  private lazy var isAdjusted = false
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    AVAPIKeyStore.sharedInstance.setAPIKey(apiKey: registrar.getAPIKey()!)
  }
  
  @IBAction func addAPIKey(_ sender: Any) {
    registrar.requestUserInputAPIKey(forViewController: self)
  }
  
  @IBAction func getAPIKey(_ sender: Any) {
    print(registrar.getAPIKey() as Any)
  }
  
  @IBAction func setAdjustedPrices(_ adjustedSwitch: UISwitch)
  {
    isAdjusted = adjustedSwitch.isOn
  }
  
  @IBAction func fetchData()
  {
    if isAdjusted {
      self.fetchAdjustedPrices()
    } else {
      self.fetchStandardPrices()
    }
  }
  
  private func fetchAdjustedPrices() {
    AVHistoricalAdjustedStockPricesBuilder()
      .setSymbol("MSFT")
      .getResults { (stocks, error) in
        print(stocks as Any)
        print(error as Any)
    }
  }
  
  private func fetchStandardPrices() {
    AVHistoricalStockPricesBuilder()
      .setSymbol("MSFT")
      .getResults { (stocks, error) in
        print(stocks as Any)
        print(error as Any)
    }
  }
}

