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
    var testBuilder = AVHistoricalStockPricesQueryBuilder()
    testBuilder
      .setSymbol("MSFT")
      .setOuputSize(.full)
      .setDataOutputType(.raw)
    print(testBuilder)
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

