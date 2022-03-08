//
//  ConfirmAccountviewModel.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//


import Foundation
import RxSwift
import RxCocoa
import RxRelay

class ConfirmAccountviewModel {
    
    private weak var view: ConfirmAccountViewController?
    private var router: ConfirmAccountRouter?
    
    var state = State()
    let isValid :  Observable<Bool>!
    var activationCode = BehaviorRelay<String>(value:"")
    var ActivationCodeResponse = ActivationLink()
    
    init() {
        isValid = Observable.combineLatest(self.activationCode.asObservable() , self.activationCode.asObservable())
        { (activationCode , activationCode) in
            return activationCode.count == 4
            && activationCode.count == 4

        }
    }
    
    func bind(view: ConfirmAccountViewController, router: ConfirmAccountRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}

extension  ConfirmAccountviewModel: validateTokenCode {
    func validateTokenCode() {
        let userEmail = LocalStorage().getownerPhone()
        let tokenCode = self.activationCode.value
        
        let parameters = ["Email":userEmail,
                          "Code":tokenCode]
        print("parameters",parameters)
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string:activationCodeApi)!)
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
                self.ActivationCodeResponse = try decoder.decode(ActivationLink.self, from: data)
                if  self.ActivationCodeResponse.successtate == 200 {
                    DispatchQueue.main.async {
                    defer{
                        self.router?.navigateToMainview()
                      }
                        LocalStorage().savelogedBefore(using: true)
                    }
                }
              
            } catch let err {
                print("Err", err)
            }
        }.resume()
       
    }
    
    
}
