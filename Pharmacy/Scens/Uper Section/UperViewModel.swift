//
//  UperViewModel.swift
//  Pharmacy
//
//  Created by A on 26/01/2022.
//


import Foundation
import RxSwift
import RxCocoa
import RxRelay

class UperViewModel{
    
    private weak var view: UperViewController?
    private var router: UperRouter?
    var headerTilte = String()
    var notificationCountInstance = PublishSubject<Int>()
    func bind(view: UperViewController, router: UperRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func rootViewtoTabBar() {
        router?.showTabBar()
    }
    
}

extension UperViewModel {
    func getNotificationCount() {
        var request = URLRequest(url: URL(string: notificationCountApi)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
//        state.isLoading.accept(true)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
//            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
//                var blog = LikeBlogModel()
                let countNotification = try decoder.decode(NoficationCount.self, from: data)
                if countNotification.successtate == 200 {
                    self.notificationCountInstance.onNext(countNotification.message ?? 0)
//                    self.likeBlogs.onNext(blog)
                }
                
                else {
                    DispatchQueue.main.async {
                     
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
    
}
