//
//  FAQViewModel.swift
//  Pharmacy
//
//  Created by taha hussein on 05/05/2022.
//

import Foundation
import UIKit
import RxRelay
import RxCocoa
import RxSwift
class FAQViewModel{
    
    private weak var view: FAQViewController?
    private var router: FAQRouter?
   var faqInstance = PublishSubject<[FAQMessage]>()
    var state = State()

    func bind(view: FAQViewController, router: FAQRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}
extension FAQViewModel {
    func getWebPage() {
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: FAQApi)!)

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
                let faqMolde: FAQModel!
                faqMolde = try decoder.decode(FAQModel.self, from: data)
                if faqMolde.successtate == 200 {
                    DispatchQueue.main.async {
                        print(faqMolde)
                        self.faqInstance.onNext(faqMolde.message ?? [])
                    }
                }
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: faqMolde.errormessage ?? "An error occured , please try again".localized, viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
