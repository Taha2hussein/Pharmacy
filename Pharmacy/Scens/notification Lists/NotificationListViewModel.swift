//
//  NotificationListViewModel.swift
//  Pharmacy
//
//  Created by taha hussein on 19/05/2022.
//

import Foundation
import UIKit
import RxRelay
import RxCocoa
import RxSwift

class NotificationListViewModel{
    
    private weak var view: NotificationListViewController?
    private var router: NotificationListRouter?
    var notificationListInstance = BehaviorSubject<[MotificaitonListMessage]>(value:[])
    var state = State()

    func bind(view: NotificationListViewController, router: NotificationListRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}
extension NotificationListViewModel {
    func getNotificationList() {
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: notificationListApi)!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
     
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                let notificationList: MotificaitonListModel!
                notificationList = try decoder.decode(MotificaitonListModel.self, from: data)
                if notificationList.successtate == 200 {
                    DispatchQueue.main.async {
                        print(notificationList)
                        self.notificationListInstance.onNext(notificationList.message ?? [])
                    }
                }
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: notificationList.errormessage ?? "An error occured , please try again".localized, viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}


extension NotificationListViewModel {
    func deleteNotificationAction(notificationID:Int) {
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: deleteNotficationApi + "\(notificationID)")!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
     
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                let deleteNotification: DeleteNotificationModel!
                deleteNotification = try decoder.decode(DeleteNotificationModel.self, from: data)
                if deleteNotification.successtate == 200 {
                    DispatchQueue.main.async {
                        print(deleteNotification)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: deleteNotification.errormessage ?? "An error occured , please try again".localized, viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}


extension NotificationListViewModel {
    func markNotificationAction(notificationID:Int) {
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: markNotificationReadApi + "\(notificationID)")!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
     
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                let markNotification: MarkNotificationRead!
                markNotification = try decoder.decode(MarkNotificationRead.self, from: data)
                if markNotification.successtate == 200 {
                    DispatchQueue.main.async {
                        print(markNotification)
                        self.view?.reloadNoticationsTableView()
                    }
                }
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: markNotification.errormessage ?? "An error occured , please try again".localized, viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}


extension NotificationListViewModel {
    func markAllNotificationAction() {
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: markAllNotificationsReadApi)!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
     
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                let markAllNotification: MarkAsReadAllNotificationModel!
                markAllNotification = try decoder.decode(MarkAsReadAllNotificationModel.self, from: data)
                if markAllNotification.successtate == 200 {
                    DispatchQueue.main.async {
                        print(markAllNotification)
                        self.view?.reloadNoticationsTableView()
                    }
                }
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: markAllNotification.errormessage ?? "An error occured , please try again".localized, viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}


extension NotificationListViewModel {
    func deleteAllNotificationAction() {
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: deleteAllNotificationApi)!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
     
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                let deleteAllNotification: DeleteAllNotificationModel!
                deleteAllNotification = try decoder.decode(DeleteAllNotificationModel.self, from: data)
                if deleteAllNotification.successtate == 200 {
                    DispatchQueue.main.async {
                        print(deleteAllNotification)
                        self.view?.removeAllNotification()
                    }
                }
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: deleteAllNotification.errormessage ?? "An error occured , please try again".localized, viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
