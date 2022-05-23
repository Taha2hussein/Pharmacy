//
//  ContactUsViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 05/05/2022.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay

class ContactUsViewController: BaseViewController {
    
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var message: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var name: UITextField!
    
    var articleDetailsViewModel = ContactUsViewModel()
    private var router = ContactUsRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backAction()
        saveAction()
        bindViewControllerRouter()
        subscribeToLoader()
        setUP()
    }
    
    func setUP(){
        message.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top
    }

    func saveAction() {
        save.rx.tap.subscribe { [weak self] _ in
            if let contactUs = ContactUsModelSent(name: self?.name.text ?? "", mobile: self?.mobile.text ?? "", email: self?.email.text ?? "", message: self?.message.text ?? "")as? ContactUsModelSent {
            self?.articleDetailsViewModel.saveContactUs(ContactUsModel: contactUs)
            }
        }.disposed(by: self.disposeBag)

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
    func backAction() {
        backButton.rx.tap.subscribe { [weak self] _ in
            self?.router.backAction()
        }.disposed(by: self.disposeBag)
    }
}
extension ContactUsViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
