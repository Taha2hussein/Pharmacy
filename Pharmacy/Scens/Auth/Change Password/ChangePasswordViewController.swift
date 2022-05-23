//
//  ChangePasswordViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 16/04/2022.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var confirmNewPassword: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var currentPasswordField: UITextField!
    
    var articleDetailsViewModel = ChangePasswordViewModel()
    private var router = ChangePasswordRouter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
//        validateData()
        subscribeToLoader()
        bindCurrentPassword()
        bindnewPassword()
        bindnewConfirmPassword()
        addTooglePasswordShowButton()
        changePasswordAction()
        backAction() 
    }
    
    func backAction() {
        backButton.rx.tap.subscribe { [weak self] _ in
            self?.router.backView()
        } .disposed(by: self.disposeBag)

    }
    
    func addTooglePasswordShowButton() {
        currentPasswordField.enablePasswordToggle(textField: currentPasswordField)
        newPasswordField.enablePasswordToggle(textField: newPasswordField)
        confirmNewPassword.enablePasswordToggle(textField: confirmNewPassword)
//        currentPasswordField.enablePasswordToggle()
//        currentPasswordField.
    }
    
    func validateData() {
        articleDetailsViewModel.isValid.subscribe(onNext: {[weak self] (isEnabled) in
            isEnabled ? (self?.saveButton.isEnabled = true) : (self?.saveButton.isEnabled = false)
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
    
    func changePasswordAction() {
        saveButton.rx.tap.subscribe { [weak self] _ in
            self?.articleDetailsViewModel.changePasswords(oldPassword:(self?.currentPasswordField.text)! , newPassword:(self?.newPasswordField.text)! , newConfirmPassword:(self?.confirmNewPassword.text)!)
        } .disposed(by: self.disposeBag)

    }
}

extension ChangePasswordViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}


extension ChangePasswordViewController {
    func bindCurrentPassword() {
        currentPasswordField.rx.text
                    .orEmpty
                    .bind(to: articleDetailsViewModel.oldPassword).disposed(by: self.disposeBag)
    }
    
    func bindnewPassword() {
        newPasswordField.rx.text
                    .orEmpty
                    .bind(to: articleDetailsViewModel.newPassword).disposed(by: self.disposeBag)
    }
    
    func bindnewConfirmPassword() {
        confirmNewPassword.rx.text
                    .orEmpty
                    .bind(to: articleDetailsViewModel.newConfirmPassword).disposed(by: self.disposeBag)
    }
}
