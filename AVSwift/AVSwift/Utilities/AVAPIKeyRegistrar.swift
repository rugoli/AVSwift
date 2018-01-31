//
//  AVAPIKeyRegistrar.swift
//  AVSwift
//
//  Created by Roshan Goli on 1/13/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

public enum AVAPIRegistrarError: Error {
  case invalidKey
}

public class AVAPIKeyRegistrar: NSObject {
  private var apiKey: String?
  
  public func getAPIKey() -> String? {
    return KeychainService.loadPassword()
  }
  
  private func registerAPIKey(apiKey: String?) throws {
    guard let key = apiKey else {
      throw AVAPIRegistrarError.invalidKey
    }
    
    // register key
    KeychainService.savePassword(token: key)
    AVAPIKeyStore.sharedInstance.setAPIKey(apiKey: key)
  }
  
  public func requestUserInputAPIKey(forViewController vc: UIViewController) {
    let alertView = UIAlertController(title: "Enter API key", message: nil, preferredStyle: .alert)
    
    alertView.addTextField(configurationHandler: nil)
    
    alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alertView, weak self] (_) in
      let textField = alertView?.textFields![0]
      try! self?.registerAPIKey(apiKey: textField?.text)
      alertView?.dismiss(animated: true, completion: nil)
    }))
    
    alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak alertView] (_) in
      alertView?.dismiss(animated: true, completion: nil)
    }))
    
   vc.present(alertView, animated: true, completion: nil)
  }

}
