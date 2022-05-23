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

    @IBOutlet weak var resendCodeTime: UIButton!
    @IBOutlet weak var ownerMobile: UILabel!
    @IBOutlet weak var enteredActivationCode: KKPinCodeTextField!
    @IBOutlet weak var resendCode: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    private var resendCodeClicksCount = PublishSubject<Int>()
    private var resendCodeClicks: Int = 0
    var articleDetailsViewModel = ConfirmAccountviewModel()
    private var router = ConfirmAccountRouter()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        activateLinkAction()
        resendCodeAction()
        subscribeToLoader()
//        validateData()
        bindActivationCode()
        bindViewControllerRouter()
        validateResendCodeClicks()
    }

    func setUI(){
        ownerMobile.text = LocalStorage().getownerEmail()
    }
    
    
    func validateResendCodeClicks() {
        resendCodeClicksCount.subscribe { [weak self] clicks in
            if let clicksCount = clicks.element {
                if clicksCount > 3 {
                    Alert().displayError(text: LocalizedStrings().resendCodeClickExceed, viewController: self!)
                }
                else {
                    self?.articleDetailsViewModel.resendActivationCode()
                }
            }
        }.disposed(by: self.disposeBag)

    }
    
    func countDownTimerForResendCode() {
        CountdownTimer().startCountdown(
                totalTime: 30,
                timerEnded: {
                    self.resendCode.isUserInteractionEnabled = true
                }, timerInProgress: { elapsedTime in
                    print(elapsedTime)
                    self.resendCode.isUserInteractionEnabled = false
                    self.resendCodeTime.setTitle("\(elapsedTime)", for: .normal)
                }
            )
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
    
    func showAlert(message:String) {
        Alert().displayError(text: message, viewController: self)
    }
    
    func validateALLField() {
        if enteredActivationCode.text!.isEmpty {
            showAlert(message: LocalizedStrings().emptyField)
        }
        
        else if enteredActivationCode.text!.count < 4 {
            showAlert(message: LocalizedStrings().validVerificationCode)
        }
        
        else {
            self.articleDetailsViewModel.validateTokenCode()
        }
        
    }
    
    func activateLinkAction() {
        confirmButton.rx.tap.subscribe { [weak self] _  in
            self?.validateALLField()
        } .disposed(by: self.disposeBag)
    }
    
    func resendCodeAction() {
        resendCode.rx.tap.subscribe { [weak self] _  in

            self?.resendCodeClicks += 1
            self?.resendCodeClicksCount.onNext(self?.resendCodeClicks ?? 0)
        } .disposed(by: self.disposeBag)

    }
    
    func showAlertForResendCode() {
        Alert().displayError(text: LocalizedStrings().resendCodeMessage, viewController: self)
    }
    
}

extension ConfirmAccountViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
