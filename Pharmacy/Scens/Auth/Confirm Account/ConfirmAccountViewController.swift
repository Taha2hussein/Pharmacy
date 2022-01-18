//
//  ConfirmAccountViewController.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import UIKit
import KKPinCodeTextField
import RxCocoa
import RxSwift
import RxRelay

class ConfirmAccountViewController: BaseViewController {

    @IBOutlet weak var ownerMobile: UILabel!
    @IBOutlet weak var enteredActivationCode: KKPinCodeTextField!
    @IBOutlet weak var resendCode: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var articleDetailsViewModel = ConfirmAccountviewModel()
    private var router = ConfirmAccountRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        activateLinkAction()
        resendCodeAction()
        subscribeToLoader()
        validateData()
        bindActivationCode()
        bindViewControllerRouter()
    }

    func setUI(){
        ownerMobile.text = LocalStorage().getownerPhone()
    }
    
    func validateData() {
        articleDetailsViewModel.isValid.subscribe(onNext: {[weak self] (isEnabled) in
            isEnabled ? (self?.confirmButton.isEnabled = true) : (self?.confirmButton.isEnabled = false)
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
    
    func bindActivationCode() {
        enteredActivationCode.rx.text.orEmpty
            .bind(to: articleDetailsViewModel.activationCode).disposed(by: self.disposeBag)
    }
    
    func activateLinkAction() {
        confirmButton.rx.tap.subscribe { [weak self] _  in
            self?.articleDetailsViewModel.validateTokenCode()
        } .disposed(by: self.disposeBag)
    }
    
    func resendCodeAction() {
        resendCode.rx.tap.subscribe { [weak self] _  in
            
        } .disposed(by: self.disposeBag)

    }
    
}

extension ConfirmAccountViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
