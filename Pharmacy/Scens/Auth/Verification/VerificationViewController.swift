//
//  VerificationViewController.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import UIKit

class VerificationViewController: BaseViewController {

    var articleDetailsViewModel = VerificationViewModel()
    private var router = VerificationRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewControllerRouter()
        // Do any additional setup after loading the view.
    }
    
    
}

extension VerificationViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
