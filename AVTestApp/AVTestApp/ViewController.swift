//
//  ViewController.swift
//  AVTestApp
//
//  Created by Roshan on 1/1/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBAction func addAPIKey(_ sender: Any) {
    let registrar = AVAPIKeyRegistrar()
    registrar.requestUserInputAPIKey(forViewController: self)
  }
}

