//
//  Validators.swift
//  Pharmacy
//
//  Created by taha hussein on 15/05/2022.
//

import Foundation
// MARK: - Email And Phone Validation
func isEmailValid(_ emailString: String) -> Bool{
    let regExPattern = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
    let emailTest = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regExPattern])

    return emailTest.evaluate(with: emailString)
}

func isValidatePhone(_ value: String) -> Bool {
      let phoneRegEx = "^[6-9]\\d{9}$"
      var phoneNumber = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
      return phoneNumber.evaluate(with: value)
       }

func isNotEmptyString(text: String, withAlertMessage message: String) -> Bool{
    if text == ""{
    
        return false
    }else{
        return true
    }
}

func isPasswordValid(_ password : String) -> Bool{
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])[A-Za-z\\d$@$#!%*?&]{8,}")
    return passwordTest.evaluate(with: password)
}
