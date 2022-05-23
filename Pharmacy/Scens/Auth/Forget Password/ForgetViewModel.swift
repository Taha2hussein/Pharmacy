//
//  ForgetViewModel.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class ForgetViewModel {
    
    private weak var view: ForgetViewController?
    private var router: ForgetPasswordRouter?
    var userMobile = BehaviorRelay<String>(value:"")
    let isValid :  Observable<Bool>!
    var state = State()
    init() {
        isValid = Observable.combineLatest(self.userMobile.asObservable() , self.userMobile.asObservable())
        { (userMobile , userMobile) in
            return userMobile.count > 0
            && userMobile.count > 0

        }
    }
    
    func bind(view: ForgetViewController, router: ForgetPasswordRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func sendAction(userMobile: String) {
        defer {
            router?.showVerificationView()
        }
        saveMobileToLocal(userMobile: userMobile)
    }
    
    func saveMobileToLocal(userMobile: String) {
        LocalStorage().saveOwnerPhone(using: userMobile)
    }
}

extension ForgetViewModel{
    func sendVerificationCode(userMobiel:String) {
//        let userMobiel  = LocalStorage().getownerPhone()
        
        let parameters = [
                          "Mobile": userMobiel,
                          "Type": 4,
                          ] as [String : Any]
        
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: forgetPasswordFirstApi)!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        request.httpBody = jsonString?.data(using: .utf8)
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                let ForgetPasswordFirst: ForgetPasswordFirstModel!
                ForgetPasswordFirst = try decoder.decode(ForgetPasswordFirstModel.self, from: data)
                if ForgetPasswordFirst.successtate == 200 {
                    DispatchQueue.main.async {
                        self.sendAction(userMobile: userMobiel)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: ForgetPasswordFirst.errormessage ?? "An error occured , please try again".localized, viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
    
}
