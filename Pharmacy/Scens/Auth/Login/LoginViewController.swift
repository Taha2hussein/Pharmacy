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

    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mboileTextField: UITextField!
    @IBOutlet weak var termsAndConditionButton: UIButton!
    
    var articleDetailsViewModel = LoginViewModel()
    private var router = LoginRouter()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewControllerRouter()
        createAccountAction()
        loginAction()
        bindMobile()
        bindPassword()
        subscribeToLoader()
        addTooglePasswordShowButton()
        forgetPassword()
        setUpPhone()
        termsAndConditionTapped()
//        validateData()
    }

    func setup() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func addTooglePasswordShowButton() {
        passwordTextField.enablePasswordToggle(textField: passwordTextField)
    }
    
    func validateData() {
        articleDetailsViewModel.isValid.subscribe(onNext: {[weak self] (isEnabled) in
            isEnabled ? (self?.loginBtn.isEnabled = true) : (self?.loginBtn.isEnabled = false)
        }).disposed(by: self.disposeBag)

    }
    
    func setUpPhone() {
        ImageCountryCode().setCountryCode(countryImage: self.flagImage)
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
    
    func termsAndConditionTapped() {
        termsAndConditionButton.rx.tap.subscribe { [weak self] _ in
            self?.router.showTermsAndcondition()
        }.disposed(by: self.disposeBag)

    }
    func forgetPassword() {
        forgetPasswordBtn.rx.tap.subscribe { [weak self] _  in
            self?.articleDetailsViewModel.showForgetPasswordView()
        }.disposed(by: self.disposeBag)

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
            self?.articleDetailsViewModel.showCreateAccount()
        } .disposed(by: self.disposeBag)

    }
    
    
    func showAlert(message:String) {
        Alert().displayError(text: message, viewController: self)
    }
    
    func validateALLField() {
        if mboileTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            showAlert(message: LocalizedStrings().emptyField)
        }
        
        else if passwordTextField.text!.count < 8 {
            showAlert(message: LocalizedStrings().passwordCount)
        }
      
        else if mboileTextField.text!.count < 11 {
            showAlert(message: LocalizedStrings().validPhoneNumber)
        }
        
        else {
        self.articleDetailsViewModel.loginUser()
        }
        
    }
    
    func loginAction() {
        loginBtn.rx.tap.subscribe { [weak self] _ in
//            self?.articleDetailsViewModel.loginUser()
            self?.validateALLField()
        } .disposed(by: self.disposeBag)

    }
}
extension LoginViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
