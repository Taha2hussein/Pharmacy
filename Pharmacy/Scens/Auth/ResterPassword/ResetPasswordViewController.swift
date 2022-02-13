//
//  ResetPasswordViewController.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay

class ResetPasswordViewController: BaseViewController {
    
    var articleDetailsViewModel = ResetPasswordViewModel()
    private var router = ResetPasswordRouter()
    
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var confirmationNewPassword: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validateData()
        subscribeToLoader()
        bindViewControllerRouter()
        bindConfirmationNewPassword()
        bindNewPassword()
        resetPasswordTapped()
    }
    
    func validateData() {
        articleDetailsViewModel.isValid.subscribe(onNext: {[weak self] (isEnabled) in
            isEnabled ? (self?.resetPasswordButton.isEnabled = true) : (self?.resetPasswordButton.isEnabled = false)
        }).disposed(by: self.disposeBag)
        
    }
    
    func subscribeToLoader() {
        articleDetailsViewModel.state.isLoading.subscribe(onNext: {[weak self] (isLoading) in
            DispatchQueue.main.async {
                if isLoading {
                    
                    self?.showLoading()
                    
                } else {
                    self?.hideLoading()
                }
            }
        }).disposed(by: self.disposeBag)
    }
    
    func resetPasswordTapped() {
        resetPasswordButton.rx.tap.subscribe { [weak self] _ in
            self?.articleDetailsViewModel.resetPassword(newPassword: self?.newPasswordTextField.text ?? "", newConfirmationPassword: self?.confirmationNewPassword.text ?? "")
        }.disposed(by: self.disposeBag)
        
    }
}

extension ResetPasswordViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
extension ResetPasswordViewController {
    func bindNewPassword() {
        newPasswordTextField.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.newPassword).disposed(by: self.disposeBag)
    }
    
    func bindConfirmationNewPassword() {
        confirmationNewPassword.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.newConfiramtionPassword).disposed(by: self.disposeBag)
    }
}
