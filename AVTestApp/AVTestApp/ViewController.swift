//
//  ViewController.swift
//  AVTestApp
//
//  Created by Roshan on 1/1/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    var testBuilder = AVHistoricalStockPricesBuilder()
    testBuilder
      .setSymbol("MSFT")
      .setOuputSize(.full)
    print(testBuilder)
    // Do any additional setup after loading the view, typically from a nib.
  }
}

