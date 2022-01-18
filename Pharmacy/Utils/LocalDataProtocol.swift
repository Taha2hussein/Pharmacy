//
//  LocalDataProtocol.swift
//  Pharmacy
//
//  Created by A on 09/01/2022.
//

import Foundation

protocol LocalDataProtocol {
    
    
    func saveFirstName(using ownerFirstName:String)
    func getownerFirstName()-> String
    
    func saveLastName(using ownerLastName:String)
    func getownerLastName()-> String
    
    func saveEmail(using ownerEmail:String)
    func getownerEmail()-> String
    
    func saveOwnerPhone(using ownerPhone:String)
    func getownerPhone()-> String
    
    func saveOwnerPassword(using ownerPassword:String)
    func getOwnerPassword()-> String
    
    func saveLocationName(locationName:String)
    func getLocationName()->String
    
    func saveLocationLatitude(latitude:Double)
    func getlocationLatitude() ->Double
    
    func saveLocationLogitude(longtitude:Double)
    func getLocationLongituded()-> Double
    
    func saveActiveLink(using ActiveLink:String)
    func getActiveLink()-> String
    
    func saveTokenCode(using tokenCode:String)
    func getTokenCode()-> String
    
    func saveDeviceToken(using deviceToken:String)
    func getdeviceToken()-> String
    
    func saveDeviceId(using deviceId:String)
    func getDeviceId()-> String
    
    func saveLoginToken(using logintoken:String)
    func getLoginToken()-> String
    
    func savelogedBefore(using logedBefore:Bool)
    func getLogedBefore()-> Bool
}