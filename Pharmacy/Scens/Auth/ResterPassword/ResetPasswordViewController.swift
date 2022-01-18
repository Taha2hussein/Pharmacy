//
//  ResetPasswordViewController.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import UIKit

class ResetPasswordViewController: BaseViewController {

    var articleDetailsViewModel = ResetPasswordViewModel()
    private var router = ResetPasswordRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewControllerRouter()
    }
   

}
extension ResetPasswordViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
