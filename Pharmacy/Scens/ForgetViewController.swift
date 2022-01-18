//
//  ForgetViewController.swift
//  Pharmacy
//
//  Created by A on 07/01/2022.
//

import UIKit

class ForgetViewController: BaseViewController {

    var articleDetailsViewModel = ForgetViewModel()
    private var router = ForgetPasswordRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
    }
  
}
extension ForgetViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
