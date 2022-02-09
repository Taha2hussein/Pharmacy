//
//  PharmacyProfileViewController.swift
//  Pharmacy
//
//  Created by A on 08/02/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
class PharmacyProfileViewController: BaseViewController {
    
    @IBOutlet weak var uperView: UIView!
    
    var articleDetailsViewModel = PharmacyProfileViewModel()
    private var router = PharmacyProfileRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        embedUperView()
        bindViewControllerRouter()
    }
    
    func embedUperView() {
        let vc = UperRouter().viewController
        self.embed(vc, inParent: self, inView: uperView)
    }

}
extension PharmacyProfileViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
