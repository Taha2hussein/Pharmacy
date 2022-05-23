//
//  ContactUsViewModel.swift
//  Pharmacy
//
//  Created by taha hussein on 05/05/2022.
//

import Foundation
import UIKit
import RxRelay
import RxCocoa
import RxSwift
class ContactUsViewModel{
    
    private weak var view: ContactUsViewController?
    private var router: ContactUsRouter?

    var state = State()

    func bind(view: ContactUsViewController, router: ContactUsRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}

extension ContactUsViewModel {
    func saveContactUs(ContactUsModel:ContactUsModelSent ) {
        let parameters = [
                          "VisitorInqueryId":0,
                          "SenderName":ContactUsModel.name,
                          "SendTime":"",
                          "SenderMobile":ContactUsModel.mobile,
                          "SenderEmail":ContactUsModel.email,
                          "InqueryText":ContactUsModel.message,
                          "InqueryType":0,
                          "LoginUserID":LocalStorage().getPharmacsitID()
                          ] as [String : Any]
        
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: contacyUsApi)!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        request.httpBody = jsonString?.data(using: .utf8)
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
        print(parameters,"parameterss")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                let logoutDecoder: ContactUsModels!
                logoutDecoder = try decoder.decode(ContactUsModels.self, from: data)
                if logoutDecoder.successtate == 200 {
                    DispatchQueue.main.async {
                        Alert().displayError(text: logoutDecoder.message ?? "An error occured , please try again".localized, viewController: self.view!)                    }
                }
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: logoutDecoder.errormessage ?? "An error occured , please try again".localized, viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
