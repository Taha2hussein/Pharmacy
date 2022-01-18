//
//  ApplicationService.swift
//  A
//

//  Copyright © 2019 A. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
class ApplicationService: NSObject, ApplicationDelegate {

    var window: UIWindow?
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

      GMSServices.provideAPIKey(Keys.googleMap.rawValue)
      GMSPlacesClient.provideAPIKey(Keys.googleMap.rawValue)
    
      
      return true
  }

  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    return false
  }
    
  
    
}

// let deviceIds = UIDevice.current.identifierForVendor!.uuidString

