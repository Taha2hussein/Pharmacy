//
//  ForgetViewController.swift
//  Pharmacy
//
//  Created by A on 07/01/2022.
//

import UIKit
import RxRelay
import RxCocoa
import RxSwift

class ForgetViewController: BaseViewController {

    var articleDetailsViewModel = ForgetViewModel()
    private var router = ForgetPasswordRouter()
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var enterMobileTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        sendTapped()
//        validateData()
        bindUserMobile()
        subscribeToLoader()
    }
    
    func validateData() {
        articleDetailsViewModel.isValid.subscribe(onNext: {[weak self] (isEnabled) in
            isEnabled ? (self?.sendButton.isEnabled = true) : (self?.sendButton.isEnabled = false)
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
    
    func bindUserMobile() {
        enterMobileTextField.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.userMobile).disposed(by: self.disposeBag)
    }
    
    func showAlert(message:String) {
        Alert().displayError(text: message, viewController: self)
    }
    
    func validateALLField() {
        if enterMobileTextField.text!.isEmpty {
            showAlert(message: LocalizedStrings().emptyField)
        }
        
       
      
        else if enterMobileTextField.text!.count < 11 {
            showAlert(message: LocalizedStrings().validPhoneNumber)
        }
        
        else {
            self.articleDetailsViewModel.sendVerificationCode(userMobiel: self.enterMobileTextField.text ?? "")
        }
        
    }
    
    func sendTapped() {
        self.sendButton.rx.tap.asObservable()
            .subscribe { [weak self] _  in
              
                self?.validateALLField()
            }.disposed(by: self.disposeBag)
    }
}

extension ForgetViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
