//
//  UperViewController.swift
//  Pharmacy
//
//  Created by A on 26/01/2022.
//

import UIKit

class UperViewController: UIViewController {
    
    var articleDetailsViewModel = UperViewModel()
    private var router = UperRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
    }
    

}
extension UperViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
