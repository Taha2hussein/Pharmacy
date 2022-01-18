//
//  ConfirmMobileViewController.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import UIKit

class ConfirmMobileViewController: BaseViewController {

    var articleDetailsViewModel = ConfirmMobileViewModel()
    private var router = ConfirmMobileRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewControllerRouter()

    }
}

extension ConfirmMobileViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
