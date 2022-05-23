//
//  OrderCancelViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 08/03/2022.
//

import UIKit
import RxCocoa
import RxRelay
import RxSwift
import SDWebImage
class OrderCancelViewController: BaseViewController {
    
    @IBOutlet weak var orderTableViewHeigh: NSLayoutConstraint!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var deliveryFeesLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var ordercost: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var orderLocation: UILabel!
    @IBOutlet weak var summaryTableView: UITableView!
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
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    var articleDetailsViewModel = OrderCanceledViewModel()
    private var router = OrderCancelRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defer {
            resizeTableViewheigh()
        }
        bindViewControllerRouter()
        subscribeToLoader()
        backTapped()
        intializeOrderData()
        bindBranchToTableView()
        articleDetailsViewModel.getOrderDetails()
        
    }
    
    func backTapped() {
        backButton.rx.tap.subscribe { [weak self] _ in
            self?.router.backAction()
        } .disposed(by: self.disposeBag)
        
    }
    
    func intializeOrderData() {
        articleDetailsViewModel.canceledOrdersInstance.subscribe { [weak self] cancelOrder in
            DispatchQueue.main.async {
                if let url = URL(string: baseURLImage + (cancelOrder.element?.patientProfileImage ?? "")) {
//                    self?.patientImage.load(url: url)
                    self?.patientImage.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar"))

                }
                self?.patientName.text = cancelOrder.element?.patientName
                self?.patientNumber.text = "\(cancelOrder.element?.patientID ?? 0)"
                self?.patientGender.text = (cancelOrder.element?.patientGender == 1) ? "Male" : "Female"
                self?.patientName.text = ( "Wt: " + "\(cancelOrder.element?.patientWeight ?? 0)" + "Kg, Ht: "  + "\(cancelOrder.element?.patientHeight ?? 0)" + "cm")
                self?.patitientEmail.text = cancelOrder.element?.patientEmail
                self?.patientName.text = cancelOrder.element?.patientName
                self?.patientPhone.text = cancelOrder.element?.patientMobile
                self?.patientCode.text = cancelOrder.element?.orderNo
                self?.orderDate.text = cancelOrder.element?.orderDate
                self?.orderPayment.text = cancelOrder.element?.paymentTypeLocalized
                self?.orderType.text = cancelOrder.element?.orderType
                self?.reasonOfCancel.text = cancelOrder.element?.cancelorderDetails?.reason
                self?.orderLocation.text = cancelOrder.element?.patientMapAddress
                self?.ordercost.text = "\(cancelOrder.element?.currentOffer?.orderFees ?? 0)"
                self?.discountLabel.text = "\(cancelOrder.element?.currentOffer?.orderDiscount ?? 0)"
                self?.deliveryFeesLabel.text = "\(cancelOrder.element?.currentOffer?.deliveryFees ?? 0)"
                self?.totalCostLabel.text = "\(cancelOrder.element?.currentOffer?.orderTotalFees ?? 0)"
                if self?.articleDetailsViewModel.singleOrderStatus == 5 {
                    self?.orderStatus.text = "Delivered".localized
                    self?.orderStatus.textColor = .green
                    self?.cancelView.isHidden = true
                }
                else if self?.articleDetailsViewModel.singleOrderStatus == 12 {
                    self?.orderStatus.text = "Canceled".localized
                    self?.orderStatus.textColor = .red
                    self?.cancelView.isHidden = false
                    
                }
            }
            
        } .disposed(by: self.disposeBag)
        
    }
    
    func resizeTableViewheigh() {
        articleDetailsViewModel.cancelOrderSummary.subscribe { [weak self] orders in
            if let orders = orders.element {
                DispatchQueue.main.async {
                    self?.orderTableViewHeigh.constant = CGFloat((orders.count * 15))

                }
            }
        }.disposed(by: self.disposeBag)

    }
    
    func bindBranchToTableView() {
        articleDetailsViewModel.cancelOrderSummary
            .bind(to: self.summaryTableView
                .rx
                .items(cellIdentifier: String(describing:  OrderCanceledTableViewCell.self),
                       cellType: OrderCanceledTableViewCell.self)) { row, model, cell in
                cell.orderCanceledLabel.text = "\(model.quantity ?? 0)" + "x " + (model.medicationNameLocalized ?? "")
                
                cell.orderCost.text = "\(model.itemFees ?? 0)"
            }.disposed(by: self.disposeBag)
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

extension OrderCancelViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
