//
//  OrderDeliveredViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 08/03/2022.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class OrderDeliveredViewController: BaseViewController {
    
    var articleDetailsViewModel = OrderDeliveredViewModel()
    private var router = OrderDeliveredRouter()
    
    @IBOutlet weak var orderSummary1: UILabel!
    @IBOutlet weak var orderSummary4: UILabel!
    @IBOutlet weak var orderSummary3: UILabel!
    @IBOutlet weak var orderSummary2: UILabel!
    @IBOutlet weak var reasonOfCancel: UILabel!
    @IBOutlet weak var orderType: UILabel!
    @IBOutlet weak var orderPayment: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var patientCode: UILabel!
    @IBOutlet weak var patientPhone: UILabel!
    @IBOutlet weak var patitientEmail: UILabel!
    @IBOutlet weak var patientWeight: UILabel!
    @IBOutlet weak var patientGender: UILabel!
    @IBOutlet weak var patientNumber: UILabel!
    @IBOutlet weak var patientImage: UIImageView!
    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var canceledBy: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        subscribeToLoader()
        backTapped()
    }
    
    func backTapped() {
        backButton.rx.tap.subscribe { [weak self] _ in
            self?.router.backAction()
        } .disposed(by: self.disposeBag)

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
}

extension OrderDeliveredViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
