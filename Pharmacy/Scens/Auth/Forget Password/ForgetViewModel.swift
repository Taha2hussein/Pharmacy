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
