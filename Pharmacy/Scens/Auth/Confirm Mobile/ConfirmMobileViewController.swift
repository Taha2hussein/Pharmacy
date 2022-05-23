//
//  ConfirmMobileViewController.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import UIKit
import RxRelay
import RxSwift
import RxCocoa
import KKPinCodeTextField

class ConfirmMobileViewController: BaseViewController {

    var articleDetailsViewModel = ConfirmMobileViewModel()
    private var router = ConfirmMobileRouter()
    private var VerfiicationViewModel = VerificationViewModel()
    @IBOutlet weak var resendCodeButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var verificationCodeTextField: KKPinCodeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validateData()
        bindViewControllerRouter()
        bindVerificationCode()
        subscribeToVerification()
        subscribeToLoader()
        resendCodeTapped()
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

    func resendCodeTapped() {
        resendCodeButton.rx.tap.subscribe { [weak self] _ in
            self?.articleDetailsViewModel.sendVerificationCode()
        }.disposed(by: self.disposeBag)

    }
    
    func subscribeToVerification() {
        confirmButton.rx.tap.subscribe { [weak self] _ in
            self?.articleDetailsViewModel.confirmMobile(viericationCode: self?.verificationCodeTextField.text ?? "")
        } .disposed(by: self.disposeBag)

    }
    
}

extension ConfirmMobileViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}

extension ConfirmMobileViewController {
    func bindVerificationCode() {
        verificationCodeTextField.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.verification).disposed(by: self.disposeBag)
    }
}
