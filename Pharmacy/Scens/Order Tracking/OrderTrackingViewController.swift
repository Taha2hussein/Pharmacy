//
//  OrderTrackingViewController.swift
//  Pharmacy
//
//  Created by Amr on 04/03/2022.
//

import UIKit
import RxCocoa
import RxRelay
import RxSwift

class OrderTrackingViewController: BaseViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var summaryTableView: UITableView!
    @IBOutlet weak var orderNotes: UILabel!
    
    var articleDetailsViewModel = OrderTrackingViewModel()
    private var router = OrderTrackingRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToLoader()
        backTapped()
        intializeOrderData()
        bindViewControllerRouter()
        acceptOrderAfterRemoveSubView()
        bindBranchToTableView()
        acceptTapped()
        CancelOrderAfterRemoveSubView()
        cancelOrderTapped()
        articleDetailsViewModel.getOrderTracking()
    }
    
    
    func backTapped() {
        backButton.rx.tap.subscribe { [weak self] _ in
            self?.router.backAction()
        } .disposed(by: self.disposeBag)
        
    }
    
    func CancelOrderAfterRemoveSubView() {
        cancelRemoveSubview.subscribe { [weak self] cancelRemove in
            if cancelRemove.element == true {
            self?.articleDetailsViewModel.cancelOrder(BranchID: branchSelected)
            }
        } .disposed(by: self.disposeBag)

    }
    
    func acceptOrderAfterRemoveSubView() {
        removeSubview.subscribe { [weak self] removeSubview in
            if removeSubview.element == true {
            self?.articleDetailsViewModel.acceptOrder(BranchID: branchSelected)
            }
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
    
    func intializeOrderData() {
        articleDetailsViewModel.orderTrackingInstance.subscribe { [weak self] orderTrackin in
            DispatchQueue.main.async {
                
                
                if let url = URL(string: baseURLImage + (orderTrackin.element?.patientProfileImage ?? "")) {
                    self?.patientImage.load(url: url)
                }
                self?.patientName.text = orderTrackin.element?.patientName
                self?.patientNumber.text = "\(orderTrackin.element?.patientID ?? 0)"
                self?.patientGender.text = (orderTrackin.element?.patientGender == 1) ? "Male" : "Female"
                self?.patientName.text = ( "Wt: " + "\(orderTrackin.element?.patientWeight ?? 0)" + "Kg, Ht: "  + "\(orderTrackin.element?.patientHeight ?? 0)" + "cm")
                self?.patitientEmail.text = orderTrackin.element?.patientEmail
                self?.patientName.text = orderTrackin.element?.patientName
                self?.patientPhone.text = orderTrackin.element?.patientMobile
                self?.patientCode.text = orderTrackin.element?.orderNo
                self?.orderDate.text = orderTrackin.element?.orderDate
                self?.orderPayment.text = orderTrackin.element?.paymentTypeLocalized
                self?.orderType.text = orderTrackin.element?.orderType
                self?.orderNotes.text =  orderTrackin.element?.orderNotes
            }
        } .disposed(by: self.disposeBag)
    }
    
    func acceptTapped() {

        addBranchesAsSubview()
    }
    
    func cancelOrderTapped() {
        showCancelationPopView()
    }
    
    func showCancelationPopView() {
        cancelButton.rx.tap.subscribe { [weak self] _ in
            let subView = UIStoryboard.init(name: Storyboards.orders.rawValue, bundle: nil).instantiateViewController(withIdentifier: ViewController.popCancelationview.rawValue)
            
            subView.view.frame = (self?.view.bounds)!
            self?.view.addSubview(subView.view)
        }.disposed(by: self.disposeBag)
    }
    
    func addBranchesAsSubview() {
        acceptButton.rx.tap.subscribe { [weak self] _ in
            let subView = UIStoryboard.init(name: Storyboards.orders.rawValue, bundle: nil).instantiateViewController(withIdentifier: ViewController.BranchesPopView.rawValue)
            
            subView.view.frame = (self?.view.bounds)!
            self?.view.addSubview(subView.view)
        }.disposed(by: self.disposeBag)

    }
    
    func bindBranchToTableView() {
        articleDetailsViewModel.orderTrackingSummary
            .bind(to: self.summaryTableView
                    .rx
                    .items(cellIdentifier: String(describing:  OrderTrackingTableViewCell.self),
                           cellType: OrderTrackingTableViewCell.self)) { row, model, cell in
                cell.summaryLabel.text = model.medicationNameLocalized
                
            }.disposed(by: self.disposeBag)
    }
}


extension OrderTrackingViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
