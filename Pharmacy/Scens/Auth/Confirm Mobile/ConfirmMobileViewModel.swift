//
//  ConfirmMobileViewModel.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class  ConfirmMobileViewModel {
    
    private weak var view: ConfirmMobileViewController?
    private var router: ConfirmMobileRouter?
    var verification = BehaviorRelay<String>(value:"")
    let isValid :  Observable<Bool>!
    var state = State()
    init() {
        isValid = Observable.combineLatest(self.verification.asObservable() , self.verification.asObservable())
        { (verification , verification) in
            return verification.count == 4
            && verification.count == 4

        }
    }
    
    func bind(view: ConfirmMobileViewController, router: ConfirmMobileRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}

extension ConfirmMobileViewModel {
    func confirmMobile(viericationCode: String) {
        let userMobiel  = LocalStorage().getownerPhone()
        let parameters = [
                          "EmailOrMobile": userMobiel,
                          "Tokencode": viericationCode,
                          ] as [String : Any]
        
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: forgetPasswordSecondApi)!)

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
                let ForgetPasswordSecond: ForgetPasswordSecondModel!
                ForgetPasswordSecond = try decoder.decode(ForgetPasswordSecondModel.self, from: data)
                if ForgetPasswordSecond.successtate == 200 {
                    DispatchQueue.main.async {
                    defer {
                        self.router?.showResetPassword()
                      }
                        LocalStorage().saveForgetPasswordId(using: ForgetPasswordSecond.message ?? "")
                    }
                }
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: ForgetPasswordSecond.errormessage ?? "An error occured , please try again".localized, viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}

extension ConfirmMobileViewModel {
    func sendVerificationCode() {
        let userMobiel  = LocalStorage().getownerPhone()
        
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
                 
                        LocalStorage().saveTokenCode(using: ForgetPasswordFirst.message?.tokencode ?? "")
                        self.view?.showAlertForResendCode()
                        self.view?.countDownTimerForResendCode()
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
