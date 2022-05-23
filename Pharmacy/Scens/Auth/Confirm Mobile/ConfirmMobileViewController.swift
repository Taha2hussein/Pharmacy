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
    private var resendCodeClicksCount = PublishSubject<Int>()
    private var resendCodeClicks: Int = 0
    
    @IBOutlet weak var resendCodeButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var verificationCodeTextField: KKPinCodeTextField!
    @IBOutlet weak var userMobilePhone: UILabel!
    @IBOutlet weak var resendCodeTime: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
//        validateData()
        bindViewControllerRouter()
        bindVerificationCode()
        subscribeToVerification()
        subscribeToLoader()
        resendCodeTapped()
        validateResendCodeClicks()
        setUp()
//        validateResendCodeClicks()
    }
    
    func setUp() {
        userMobilePhone.text = LocalStorage().getownerPhone()
    }
    
    func validateData() {
        articleDetailsViewModel.isValid.subscribe(onNext: {[weak self] (isEnabled) in
            isEnabled ? (self?.confirmButton.isEnabled = true) : (self?.confirmButton.isEnabled = false)
        }).disposed(by: self.disposeBag)

    }
    
    func countDownTimerForResendCode() {
        CountdownTimer().startCountdown(
                totalTime: 30,
                timerEnded: {
                    print("Countdown is over")
                    self.resendCodeButton.isUserInteractionEnabled = true
                }, timerInProgress: { elapsedTime in
                    print(elapsedTime)
                    self.resendCodeButton.isUserInteractionEnabled = false
                    self.resendCodeTime.setTitle("\(elapsedTime)", for: .normal)
                }
            )
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

    func showAlertForResendCode() {
        Alert().displayError(text: LocalizedStrings().resendCodeMessage, viewController: self)
    }
    
    func validateResendCodeClicks() {
        resendCodeClicksCount.subscribe { [weak self] clicks in
            if let clicksCount = clicks.element {
                if clicksCount > 3 {
                    Alert().displayError(text: LocalizedStrings().resendCodeClickExceed, viewController: self!)
                }
                else {
                    self?.articleDetailsViewModel.sendVerificationCode()
                }
            }
        }.disposed(by: self.disposeBag)

    }
    
    func resendCodeTapped() {
        resendCodeButton.rx.tap.subscribe { [weak self] _ in
//            self?.articleDetailsViewModel.sendVerificationCode()
            self?.resendCodeClicks += 1
            self?.resendCodeClicksCount.onNext(self?.resendCodeClicks ?? 0)
        }.disposed(by: self.disposeBag)

    }
    
    func showAlert(message:String) {
        Alert().displayError(text: message, viewController: self)
    }
    
    func validateALLField() {
        if verificationCodeTextField.text!.isEmpty {
            showAlert(message: LocalizedStrings().emptyField)
        }
        
        else if verificationCodeTextField.text!.count < 4 {
            showAlert(message: LocalizedStrings().validVerificationCode)
        }
        
        else {
            self.articleDetailsViewModel.confirmMobile(viericationCode: self.verificationCodeTextField.text ?? "")
        }
        
    }
    
    func subscribeToVerification() {
        confirmButton.rx.tap.subscribe { [weak self] _ in
            self?.validateALLField()
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
