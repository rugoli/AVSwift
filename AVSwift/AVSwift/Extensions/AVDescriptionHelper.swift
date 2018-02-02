//
//  AVDescriptionHelper.swift
//  AVSwift
//
//  Created by Roshan Goli on 2/1/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

protocol AVObjectDescription {
  func description(for: Any) -> String
}

extension AVObjectDescription {
  func description(for object: Any) -> String {
    var descriptionString = "\n"
    let objectMirror = Mirror(reflecting: object)
    for child in objectMirror.children {
      if let propertyName = child.label {
        descriptionString += "\n\(propertyName): \(child.value)"
      }
    }
    return descriptionString
  }
}
