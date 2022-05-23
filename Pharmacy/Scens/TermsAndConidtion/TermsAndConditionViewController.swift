//
//  TermsAndConditionViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 05/05/2022.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay

class TermsAndConditionViewController: BaseViewController {

    @IBOutlet weak var termsAndConditionTextView: UITextView!
    var articleDetailsViewModel = TermsAndConditionViewModel()
    
    @IBOutlet weak var backButton: UIButton!
    private var router = TermsAndConditionRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        backTapped()
        subscribeToLoader()
        articleDetailsViewModel.getWebPage()
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
extension TermsAndConditionViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
