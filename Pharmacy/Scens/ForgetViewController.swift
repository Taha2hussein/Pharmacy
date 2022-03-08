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
        validateData()
        bindUserMobile()
    }
    
    func validateData() {
        articleDetailsViewModel.isValid.subscribe(onNext: {[weak self] (isEnabled) in
            isEnabled ? (self?.sendButton.isEnabled = true) : (self?.sendButton.isEnabled = false)
        }).disposed(by: self.disposeBag)

    }
    
    func bindUserMobile() {
        enterMobileTextField.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.userMobile).disposed(by: self.disposeBag)
    }
    
    func sendTapped() {
        self.sendButton.rx.tap.asObservable()
            .subscribe { [weak self] _  in
                self?.articleDetailsViewModel.sendAction(userMobile: self?.enterMobileTextField.text ?? "")
            }.disposed(by: self.disposeBag)
    }
}

extension ForgetViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
