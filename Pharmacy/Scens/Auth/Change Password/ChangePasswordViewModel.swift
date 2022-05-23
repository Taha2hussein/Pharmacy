//
//  ChangePasswordViewModel.swift
//  Pharmacy
//
//  Created by taha hussein on 16/04/2022.
//


import Foundation
import RxSwift
import RxCocoa
import RxRelay

class ChangePasswordViewModel{
    
    private weak var view: ChangePasswordViewController?
    private var router: ChangePasswordRouter?
    let isValid :  Observable<Bool>!
    var oldPassword = BehaviorRelay<String>(value:"")
    var newPassword = BehaviorRelay<String>(value:"")
    var newConfirmPassword = BehaviorRelay<String>(value:"")
    var changePasswordResonse : ChangePasswordModel?

    var state = State()
    
    init() {
        isValid = Observable.combineLatest(self.oldPassword.asObservable(),   self.newPassword.asObservable(),self.newConfirmPassword.asObservable())
        { ( oldPassword , newPassword,newConfirmPassword) in
            return oldPassword.count > 0
            && newPassword.count > 0
            && newConfirmPassword.count > 0
        }
    }
    
    func bind(view: ChangePasswordViewController, router: ChangePasswordRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func changePasswords(oldPassword:String , newPassword:String , newConfirmPassword:String) {
   
        let parameters = ["oldPassword":oldPassword,
                          "NewPassword":newPassword,
                          "NewPasswordConfirm":newConfirmPassword,
                          "id":LocalStorage().getPharmacsitID(),
                          "Type":4] as [String : Any]
        
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string:changePasswordApi)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        request.httpBody = jsonString?.data(using: .utf8)
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
print(parameters,"parametersChange")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                self.changePasswordResonse = try decoder.decode(ChangePasswordModel.self, from: data)

                if  self.changePasswordResonse?.successtate == 200 {
                    DispatchQueue.main.async {
                            self.router?.navigateToDetailsView()
                     
                    }
                }
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: self.changePasswordResonse?.errormessage ?? "An error occured , please try again".localized, viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
