//
//  PrivacyPolicyViewModel.swift
//  Pharmacy
//
//  Created by taha hussein on 05/05/2022.
//

import Foundation
import UIKit
import RxRelay
import RxCocoa
import RxSwift
class PrivacyPolicyViewModel{
    
    private weak var view: PrivacyPolicyViewController?
    private var router: PrivacyPolicyRouter?

    var state = State()
    var Files = BehaviorSubject<[File]>(value: [])
   var basicData = PublishSubject<BasicDataModel>()
    let selectedImageOwner = PublishSubject<UIImage>()
    let selectedImagesForLicence =  BehaviorSubject<[UIImage]>(value: [])

    func bind(view: PrivacyPolicyViewController, router: PrivacyPolicyRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}
extension PrivacyPolicyViewModel {
    func getWebPage() {
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: commonWEBPage)!)

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
                let logoutDecoder: CommonWebPageModel!
                logoutDecoder = try decoder.decode(CommonWebPageModel.self, from: data)
                if logoutDecoder.successtate == 200 {
                    DispatchQueue.main.async {
//                        self.view?.contentTextView.text = logoutDecoder.message?[3].content
                        if let blogText = logoutDecoder.message?[3].content?.htmlAttributed(family: "Segoe UI", size: 15, color: .red){
                            self.view?.contentTextView.text = blogText.string
                        }
//                        self.view?.contentTextView.adjustUITextViewHeight()
                    }
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
