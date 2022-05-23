//
//  UseCase.swift
//  BeyondTask
//
//  Created by A on 29/12/2021.
//

import UIKit
import MOLH
protocol pushView {
    func pushNextView()
}
protocol getLocationAdress {
    func getLocationAdress(_ pdblLatitude: String, _ pdblLongitude: String,completion:@escaping(String)-> Void)
}

protocol backView {
    func backNavigationview()
}

protocol getAllCountries {
    func getAllCountry()
}

protocol validateTokenCode {
    func validateTokenCode()
}

protocol uperSection {
    func embedUperView(uperView: UIView)
}

func getCurrentLanguage() -> String {
    if MOLHLanguage.currentAppleLanguage() == "en" {
        return "2"
    }
    else  if MOLHLanguage.currentAppleLanguage() == "ar"{
        return "1"
    }
    else {
        return "2"
    }
}
