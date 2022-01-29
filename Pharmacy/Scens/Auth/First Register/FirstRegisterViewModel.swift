//
//  FirstRegisterViewModel.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//


import Foundation
import RxSwift
import RxCocoa
import RxRelay
import WPMediaPicker
import UIKit

class FirstRegisterViewModel {
    
    private weak var view: RegisterViewController?
    private var router: FirstRegisterRouter?
    
    let isValid :  Observable<Bool>!
    var firstName = BehaviorRelay<String>(value:"")
    var lastName = BehaviorRelay<String>(value:"")
    var email = BehaviorRelay<String>(value:"")
    var phone = BehaviorRelay<String>(value:"")
    var password = BehaviorRelay<String>(value:"")
    var registerData = LocalStorage()
    let selectedImageOwner = PublishSubject<UIImage>()

    func bind(view: RegisterViewController, router: FirstRegisterRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    init() {
        isValid = Observable.combineLatest(
            self.firstName.asObservable(),
            self.lastName.asObservable() ,
            self.email.asObservable() ,
            self.phone.asObservable() ,
            self.password.asObservable()
        )
        { (firstName, lastName , email , password , phone) in
            return firstName.count > 0
            && lastName.count > 0
            && email.count > 0
            && phone.count > 0
            && password.count > 0
        }
    }
    
    func assignDataToSingelton() {
        registerData.saveFirstName(using: firstName.value)
        registerData.saveLastName(using: lastName.value)
        registerData.saveEmail(using: email.value)
        registerData.saveOwnerPhone(using: phone.value)
        registerData.saveOwnerPassword(using: password.value)
    }
}

extension FirstRegisterViewModel: pushView {
    func pushNextView() {
        
        router?.navigateToCompleteRegisterView()
    }
}
