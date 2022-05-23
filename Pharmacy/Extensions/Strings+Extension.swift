//
//  Strings+Extension.swift
//  Pharmacy
//
//  Created by taha hussein on 27/03/2022.
//

import Foundation
extension String {

  var localized: String {
    return NSLocalizedString(self, comment: "\(self)_comment")
  }
  
  func localized(_ args: [CVarArg]) -> String {
    return localized(args)
  }
  
  func localized(_ args: CVarArg...) -> String {
    return String(format: localized, args)
  }
}
