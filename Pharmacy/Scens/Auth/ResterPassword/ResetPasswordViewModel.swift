//
//  ResetPasswordViewModel.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class ResetPasswordViewModel {
    
    private weak var view: ResetPasswordViewController?
    private var router: ResetPasswordRouter?
    var newPassword = BehaviorRelay<String>(value:"")
    var newConfiramtionPassword = BehaviorRelay<String>(value:"")
    let isValid :  Observable<Bool>!
    var state = State()
    init() {
        isValid = Observable.combineLatest(self.newPassword.asObservable() , self.newConfiramtionPassword.asObservable())
        { (newPassword , newConfiramtionPassword) in
            return newPassword.count > 0
            && newConfiramtionPassword.count > 0
            
        }
    }
    
    func bind(view: ResetPasswordViewController, router: ResetPasswordRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}

extension ResetPasswordViewModel {
    func resetPassword(newPassword: String , newConfirmationPassword: String) {
        guard newPassword == newConfirmationPassword else {return}
        let tokenCode = LocalStorage().getTokenCode()
        let id = LocalStorage().getForgetPasswordId()
        let parameters = [
            "Type": 4,
            "Tokencode": tokenCode,
            "id": id,
            "NewPassword": newPassword,
            "NewPasswordConfirm": newConfirmationPassword
        ] as [String : Any]
        
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: forgetPasswordthirdApi)!)
        print("parametersss", parameters)
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
                let ForgetPasswordThird: ForgetPasswordThirdModel!
                ForgetPasswordThird = try decoder.decode(ForgetPasswordThirdModel.self, from: data)
                if ForgetPasswordThird.successtate == 200 {
                    DispatchQueue.main.async {
                        self.router?.showLoginView()
                    }
                }
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: ForgetPasswordThird.errormessage ?? "An error occured , please try again".localized, viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
