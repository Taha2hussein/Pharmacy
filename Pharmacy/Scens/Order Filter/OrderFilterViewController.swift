//
//  OrderFilterViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 20/05/2022.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
class OrderFilterViewController: BaseViewController {

    
    var articleDetailsViewModel = OrderFilterViewModel()
    private var router = OrderFilterRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewControllerRouter()
        
    }

}

extension OrderFilterViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
