//
//  VerificationViewController.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class VerificationViewController: BaseViewController {

    var articleDetailsViewModel = VerificationViewModel()
    private var router = VerificationRouter()
    
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneTapped()
        bindViewControllerRouter()
        subscribeToLoader()
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
    
    func doneTapped() {
        doneButton.rx.tap.subscribe { [weak self] _ in
            self?.articleDetailsViewModel.sendVerificationCode()
        }.disposed(by: self.disposeBag)

    }
}

extension VerificationViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
