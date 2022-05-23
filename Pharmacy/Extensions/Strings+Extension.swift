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

func convertDateFormat(inputDate: String) -> String {

    let dateFormatterGet = DateFormatter()
       dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
       let dateFormatterPrint = DateFormatter()
       dateFormatterPrint.dateFormat = "MMM dd yyyy h:mm a"  //"MMM d, h:mm a" for  Sep 12, 2:11 PM
       let datee = dateFormatterGet.date(from: inputDate)
     return dateFormatterPrint.string(from: datee ?? Date())
}



