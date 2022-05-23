//
//  AppDelegate+Extension.swift
//  Pharmacy
//
//  Created by taha hussein on 03/04/2022.
//

import UIKit
import Firebase
import FirebaseMessaging
extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler:
    @escaping (UNNotificationPresentationOptions) -> Void
  ) {
      let id = notification.request.content.body

      print(id , "notificationss")
      receivedAcceptedNotificationFromPatient.onNext(Int(id) ?? 0)
    completionHandler([[.banner, .sound]])
  }

  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    completionHandler()
  }
    
  
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
     
      // Print message ID.
        let orderId : Int = userInfo["gcm.notification.OrderId"] as? Int ?? 0
      
        receivedAcceptedNotificationFromPatient.onNext(orderId)


      // Print full message.
      print("%@", userInfo)
    }
}
extension AppDelegate: MessagingDelegate {
  func messaging(
    _ messaging: Messaging,
    didReceiveRegistrationToken fcmToken: String?
  ) {
      if let fcmToken = fcmToken {
    let tokenDict = ["token": fcmToken]
      LocalStorage().saveDeviceToken(using: fcmToken)
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: tokenDict)
      }
  }
}
