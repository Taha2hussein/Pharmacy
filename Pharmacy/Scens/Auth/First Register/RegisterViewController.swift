//
//  RegisterViewController.swift
//  Pharmacy
//
//  Created by A on 07/01/2022.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay
class RegisterViewController: BaseViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var phoneCode: UITextField!
    @IBOutlet weak var ownerEmail: UITextField!
    @IBOutlet weak var ownertLastName: UITextField!
    @IBOutlet weak var ownertFirstName: UITextField!
    @IBOutlet weak var ownerImage: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var articleDetailsViewModel = FirstRegisterViewModel()
    private var router = FirstRegisterRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        subscribeToContinueRegister()
        bindFirstName()
        bindLastName()
        bindEmail()
        bindMobile()
        bindPassword()
        validateData()
    }

    
    func validateData() {
        articleDetailsViewModel.isValid.subscribe(onNext: {[weak self] (isEnabled) in
            isEnabled ? (self?.nextButton.isEnabled = true) : (self?.nextButton.isEnabled = false)
        }).disposed(by: self.disposeBag)

    }
    
    func pushCompleteRegisterView() {
        defer{
            pushView()
        }
        assignValueToLocal()
    }
    
    func pushView() {
        articleDetailsViewModel.pushNextView()
    }
    
    func assignValueToLocal() {
        articleDetailsViewModel.assignDataToSingelton()
    }

}

extension RegisterViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}

extension RegisterViewController {
    func subscribeToContinueRegister() {
        nextButton.rx.tap.subscribe { [weak self] _ in
            self?.pushCompleteRegisterView()
        } .disposed(by: self.disposeBag)
    }
}

extension RegisterViewController {
    
    func bindFirstName() {
        ownertFirstName.rx.text
                    .orEmpty
                    .bind(to: articleDetailsViewModel.firstName).disposed(by: self.disposeBag)
    }
    
    func bindLastName() {
        ownertLastName.rx.text
                    .orEmpty
                    .bind(to: articleDetailsViewModel.lastName).disposed(by: self.disposeBag)
    }
    
    func bindEmail() {
        ownerEmail.rx.text
                    .orEmpty
                    .bind(to: articleDetailsViewModel.email).disposed(by: self.disposeBag)
    }
    
    func bindMobile() {
        phoneTextField.rx.text
                    .orEmpty
                    .bind(to: articleDetailsViewModel.phone).disposed(by: self.disposeBag)
    }
    
    func bindPassword() {
        passwordTextField.rx.text
                    .orEmpty
                    .bind(to: articleDetailsViewModel.password).disposed(by: self.disposeBag)
    }
}
