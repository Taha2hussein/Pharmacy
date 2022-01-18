//
//  LoginViewModel.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class LoginViewModel{
    
    private weak var view: LoginViewController?
    private var router: LoginRouter?
    let isValid :  Observable<Bool>!
    var phone = BehaviorRelay<String>(value:"")
    var password = BehaviorRelay<String>(value:"")
    var loginResponse = LoginModel()

    var state = State()
    
    init() {
        isValid = Observable.combineLatest(self.phone.asObservable(),   self.password.asObservable())
        { ( password , phone) in
            return phone.count > 0
            && password.count > 0
        }
    }
    
    func bind(view: LoginViewController, router: LoginRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
 
    func loginUser() {
        let deviceId = LocalStorage().getDeviceId()
        let deviceToken = LocalStorage().getdeviceToken()
        
        let parameters = ["Username":phone.value,
                          "Password":password.value,
                          "Decvice_id":deviceId,
                          "Device_token":deviceToken,
                          "PatientMobileCode":"+2",
                          "UserType":4] as [String : Any]
        
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string:loginApi)!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        request.httpBody = jsonString?.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                self.loginResponse = try decoder.decode(LoginModel.self, from: data)
                if  self.loginResponse.apiresponseresult?.successtate == 200 {
                    DispatchQueue.main.async {
                        defer {
                            self.router?.navigateToDetailsView()
                        }
                        LocalStorage().savelogedBefore(using: true)
                        LocalStorage().saveLoginToken(using: self.loginResponse.token ?? "")
                    }
                }
              
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}

extension LoginViewModel: pushView{
    func pushNextView() {
        router?.navigateToDetailsView()
    }
}
