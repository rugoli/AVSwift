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
  
  @IBAction func fetchDailyStocks(_ sender: Any) {
    AVHistoricalStockPricesBuilder()
      .setSymbol("MSFT")
      .withAdjustedPrices()
      .getResults { (stocks, error) in
        print(stocks as Any)
        print(error as Any)
      }
  }
  
  @IBAction func fetchWeeklyStocks(_ sender: Any) {
    AVHistoricalStockPricesBuilder()
      .setSymbol("MSFT")
      .setPeriodicity(.weekly)
      .getResults { (stocks, error) in
        print(stocks as Any)
      }
  }
}

