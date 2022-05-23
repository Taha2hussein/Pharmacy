//
//  PrivacyPolicyViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 05/05/2022.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay

class PrivacyPolicyViewController: BaseViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    
    var articleDetailsViewModel = PrivacyPolicyViewModel()
    private var router = PrivacyPolicyRouter()
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        backTapped()
        articleDetailsViewModel.getWebPage()
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
    
    func backTapped() {
        backButton.rx.tap.subscribe { [weak self] _ in
            self?.router.backAction()
        } .disposed(by: self.disposeBag)

    }

}
extension PrivacyPolicyViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
