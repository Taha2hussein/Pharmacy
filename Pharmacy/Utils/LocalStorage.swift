//
//  LocalStorage.swift
//  Pharmacy
//
//  Created by A on 09/01/2022.
//

import Foundation
import UIKit

struct LocalStorage:LocalDataProtocol {
    
    
    private let firstName = "ownerFirstName"
    private let lastName = "ownerLastName"
    private let email = "ownerEmail"
    private let Phone = "ownerPhone"
    private let ownerImage = "ownerImage"
    private let password = "ownerPassword"
    private let locationName = "LocationName"
    private let locationLatitude = "locationLatitude"
    private let locationLongtiude = "locationLongtiude"
    private let registerActiveLink = "activateLink"
    private let tokenCode = "tokenCode"
    private let deviceToken = "deviceToken"
    private let deviceID = "deviceID"
    private let loginToken = "loginToken"
    private let logedBefore =  "logedBefore"
    private let pharmacyProvider = "pharmacyProvider"
    private let pharmcistId = "PharmcistID"
    private let forgetPasswordId = "forgetPasswordId"
    
    func saveFirstName(using ownerFirstName: String) {
        UserDefaults.standard.set(ownerFirstName, forKey: self.firstName)
    }
    
    func getownerFirstName() -> String {
        return UserDefaults.standard.object(forKey: self.firstName) as? String ?? ""
    }
    
    func saveLastName(using ownerLastName: String) {
        UserDefaults.standard.set(ownerLastName, forKey: self.lastName)
    }
    
    func getownerLastName() -> String {
        return UserDefaults.standard.object(forKey: self.lastName) as? String ?? ""
    }
    
    func saveOwnerImage(using image: UIImage) {
        UserDefaults.standard.set(image, forKey: self.ownerImage)

    }
    
    func savePharmacyProviderFk(using pharmacyProviderFk: Int) {
        UserDefaults.standard.set(pharmacyProviderFk, forKey: self.pharmacyProvider)

    }
    
    func getPharmacyProviderFk()-> Int {
        //pharmacyProvider
        return UserDefaults.standard.object(forKey: self.pharmacyProvider) as? Int ?? 0

    }
    
    func getOwnerImage()-> UIImage {
        return UserDefaults.standard.object(forKey: self.ownerImage) as! UIImage

    }
    
    func saveEmail(using ownerEmail: String) {
        UserDefaults.standard.set(ownerEmail, forKey: self.email)

    }
    
    func getownerEmail() -> String {
        return UserDefaults.standard.object(forKey: self.email)as? String ?? ""
    }
    
    func saveOwnerPhone(using ownerPhone: String) {
        UserDefaults.standard.set(ownerPhone, forKey: self.Phone)

    }
    
    func getownerPhone() -> String {
        return UserDefaults.standard.object(forKey: self.Phone) as? String ?? ""
    }
    
    func saveOwnerPassword(using ownerPassword: String) {
        UserDefaults.standard.set(ownerPassword, forKey: self.password)

    }
    
    func getOwnerPassword() -> String {
        return UserDefaults.standard.object(forKey: self.password)as? String ?? ""
    }
    
    func saveLocationName(locationName: String) {
        UserDefaults.standard.set(locationName, forKey: self.locationName)
    }
    
    func getLocationName() -> String {
        return UserDefaults.standard.object(forKey: self.locationName)as? String ?? ""
    }
    
    func saveLocationLatitude(latitude: Double) {
        UserDefaults.standard.set(latitude, forKey: self.locationLatitude)
    }
    
    func getlocationLatitude() -> Double {
        return UserDefaults.standard.object(forKey: self.locationLatitude)as? Double ?? 0.0
    }
    
    func saveLocationLogitude(longtitude: Double) {
        UserDefaults.standard.set(longtitude, forKey: self.locationLongtiude)
    }
    
    func getLocationLongituded() -> Double {
        return UserDefaults.standard.object(forKey: self.locationLongtiude)as? Double ?? 0.0

    }
    
    func saveActiveLink(using ActiveLink: String) {
        UserDefaults.standard.set(ActiveLink, forKey: self.registerActiveLink)
    }
    
    func getActiveLink() -> String {
        return UserDefaults.standard.object(forKey: self.registerActiveLink)as? String ?? ""
    }
    
    func saveTokenCode(using tokenCode: String) {
        UserDefaults.standard.set(tokenCode, forKey: self.tokenCode)
    }
    
    func getTokenCode() -> String {
        return UserDefaults.standard.object(forKey: self.tokenCode)as? String ?? ""
    }
    
    func saveDeviceToken(using deviceToken: String) {
        UserDefaults.standard.set(deviceToken, forKey: self.deviceToken)

    }
    
    func getdeviceToken() -> String {
        return UserDefaults.standard.object(forKey: self.deviceToken)as? String ?? ""
    }
    
    func saveDeviceId(using deviceId: String) {
        UserDefaults.standard.set(deviceId, forKey: self.deviceID)

    }
    
    func getDeviceId() -> String {
        return UserDefaults.standard.object(forKey: self.deviceID)as? String ?? ""
    }
    
    func saveLoginToken(using logintoken: String) {
        UserDefaults.standard.set(logintoken, forKey: self.loginToken)

    }
    
    func getLoginToken() -> String {
        return UserDefaults.standard.object(forKey: self.loginToken)as? String ?? ""

    }

    func savelogedBefore(using logedBefore:Bool) {
        UserDefaults.standard.set(logedBefore, forKey: self.logedBefore)

    }
    
    func getLogedBefore()-> Bool {
        return UserDefaults.standard.object(forKey: self.logedBefore)as? Bool ?? false

    }
   
    func savePharmacistID(using  pharmacistId: Int) {
        UserDefaults.standard.set(pharmacistId, forKey: self.pharmcistId)

    }
    
    func getPharmacsitID() -> Int {
        return UserDefaults.standard.object(forKey: self.pharmcistId)as? Int ?? 0

    }
    
    func saveForgetPasswordId(using id: String) {
        UserDefaults.standard.set(id, forKey: self.forgetPasswordId)

    }
    
    func getForgetPasswordId() -> String {
        return UserDefaults.standard.object(forKey: self.forgetPasswordId)as? String ?? ""

    }
    
}

enum UserCurrentState:String {
    case Validation_Code
    case Mobile_Validation
    case Login
    case SetPin
}

