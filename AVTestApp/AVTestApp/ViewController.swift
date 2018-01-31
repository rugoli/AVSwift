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
  
  @IBAction func addAPIKey(_ sender: Any) {
    registrar.requestUserInputAPIKey(forViewController: self)
  }
  
  @IBAction func getAPIKey(_ sender: Any) {
    print(registrar.getAPIKey())
  }
}

