//
//  MoreViewModel.swift
//  Pharmacy
//
//  Created by A on 30/01/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class MoreViewModel{
    
    private weak var view: MoreViewController?
    private var router: MoreRouter?
    var state = State()

    func bind(view: MoreViewController, router: MoreRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func showProfile() {
        router?.showProfile()
    }
}

extension MoreViewModel: uperSection {
    func embedUperView(uperView: UIView) {
        router?.embedUperView(uperView: uperView)
    }
    
    func showBlogs() {
        router?.showBlogs()
    }
    
    func logout() {
        let deviceId = LocalStorage().getDeviceId()
        let deviceToken = LocalStorage().getdeviceToken()
        
        let parameters = [
                          "Decvice_id":deviceId,
                          "Device_token":deviceToken,
                          ] as [String : Any]
        
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: logoutApi)!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        request.httpBody = jsonString?.data(using: .utf8)
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                let logoutDecoder: LogoutModel!
                logoutDecoder = try decoder.decode(LogoutModel.self, from: data)
                if logoutDecoder.successtate == 200 {
                    DispatchQueue.main.async {
                    defer {
                    self.router?.rootToLogin()
                    }
                    LocalStorage().savelogedBefore(using: false)
                    }
                }
                else {
                    DispatchQueue.main.async {
                    Alert().displayError(text: logoutDecoder.errormessage ?? "An error occured , please try again", viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
