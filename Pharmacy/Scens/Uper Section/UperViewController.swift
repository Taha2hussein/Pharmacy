//
//  UperViewController.swift
//  Pharmacy
//
//  Created by A on 26/01/2022.
//

import UIKit
import RxCocoa
import RxRelay
import RxSwift

class UperViewController: BaseViewController {
    
    @IBOutlet weak var homebutton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var notificationButton: UIButton!
    
    var articleDetailsViewModel = UperViewModel()
    private var router = UperRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        showHomeView()
    }
    
    func showHomeView() {
        homebutton.rx.tap.subscribe { [weak self] _ in
            self?.articleDetailsViewModel.rootViewtoTabBar()
        } .disposed(by: self.disposeBag)

    }

}
extension UperViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
