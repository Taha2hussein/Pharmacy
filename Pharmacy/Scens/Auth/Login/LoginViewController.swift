//
//  LoginViewController.swift
//  Pharmacy
//
//  Created by A on 07/01/2022.
//

import UIKit
import RxCocoa
import RxSwift
class LoginViewController: BaseViewController {

    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mboileTextField: UITextField!
    
    var articleDetailsViewModel = LoginViewModel()
    private var router = LoginRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        createAccountAction()
        loginAction()
        bindMobile()
        bindPassword()
        subscribeToLoader()
        validateData()
        self.navigationController?.navigationBar.isHidden = true
    }
   
    func validateData() {
        articleDetailsViewModel.isValid.subscribe(onNext: {[weak self] (isEnabled) in
            isEnabled ? (self?.loginBtn.isEnabled = true) : (self?.loginBtn.isEnabled = false)
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
    
    func bindMobile() {
        mboileTextField.rx.text
                    .orEmpty
                    .bind(to: articleDetailsViewModel.phone).disposed(by: self.disposeBag)
    }
    
    func bindPassword() {
        passwordTextField.rx.text
                    .orEmpty
                    .bind(to: articleDetailsViewModel.password).disposed(by: self.disposeBag)
    }
    
    func createAccountAction() {
        createAccountBtn.rx.tap.subscribe { [weak self]_ in
            self?.articleDetailsViewModel.pushNextView()
        } .disposed(by: self.disposeBag)

    }
    
    func loginAction() {
        loginBtn.rx.tap.subscribe { [weak self] _ in
            self?.articleDetailsViewModel.loginUser()
        } .disposed(by: self.disposeBag)

    }
}
extension LoginViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
