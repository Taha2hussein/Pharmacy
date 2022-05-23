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

 var offerPharmacyOrderId = Int()
var toggleFinishOrderView = PublishSubject<Bool>()
class OrderTrackingViewController: BaseViewController {
    
    // received
    @IBOutlet weak var receivedViewHeight: NSLayoutConstraint!
    @IBOutlet weak var receivedFlagColor: UIView!
    @IBOutlet weak var receivedViewDetails: UIView!
    @IBOutlet weak var receivedOrderLabel: UILabel!
    @IBOutlet weak var receivedORderPricingButton: UIButton!
    
    @IBOutlet weak var filesCollectionView: UICollectionView!
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
    
    @IBOutlet weak var preparingOrderHeigh: NSLayoutConstraint!
    
    @IBOutlet weak var preparingView: UIView!
    @IBOutlet weak var finishView: UIView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var noShow: UIButton!
    @IBOutlet weak var finishOrderHeigh: NSLayoutConstraint!
    
    @IBOutlet weak var pricingViewHeigh: NSLayoutConstraint!
    @IBOutlet weak var cancelPricing: UIButton!
    @IBOutlet weak var acceptPricing: UIButton!
    @IBOutlet weak var editPricingButton: UIButton!
    @IBOutlet weak var pricingTableView: UITableView!
    var articleDetailsViewModel = OrderTrackingViewModel()
    private var router = OrderTrackingRouter()
    private var OrderTracking: OrderTrackingMessage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToLoader()
        backTapped()
        setup()
        pricingButtonTapped()
        intializeOrderData()
        bindViewControllerRouter()
        acceptOrderAfterRemoveSubView()
        bindBranchToTableView()
        acceptTapped()
        CancelOrderAfterRemoveSubView()
        cancelOrderTapped()
        subcribeToFiles()
        bindPricingMeddicineToTableView()
        cancelPricingTapped()
        bindfilesToCollectionview()
        subcribeToOrders()
        showPricingView()
        acceptPricingTapped()
        noShowButtonTapped()
        showFinishView()
        finishOrder()
        showFinishViewDirectly()
        validateViewFromNeedAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        articleDetailsViewModel.getOrderTracking()

    }
    
    func validateViewFromNeedAction() {
        print("ddd",articleDetailsViewModel.singleOrderStatus)
        if articleDetailsViewModel.singleOrderStatus == 0 {
            
        }
        
        else if articleDetailsViewModel.singleOrderStatus == 1 {
            cancelButton.isHidden = true
            acceptButton.isHidden = true
            showReceivedView()
        }
        
        else{
            
        }
    }
    
    func showFinishViewDirectly() {
        if orderSelected == .upcoming {
           receivedORderPricingButton.isHidden = true
            cancelButton.isHidden = true
            acceptButton.isHidden = true
            acceptPricing.isHidden = true
            cancelPricing.isHidden = true
            pricingViewHeigh.constant = 250
            finishOrderHeigh.constant = 100
            preparingOrderHeigh.constant = 100
            receivedViewHeight.constant = 100
            preparingView.isHidden = false
            finishView.isHidden = false
        }
    }
    
    func setup() {
        self.receivedViewHeight.constant = 0
        self.pricingViewHeigh.constant = 30
        self.preparingOrderHeigh.constant = 30
        self.finishOrderHeigh.constant = 30
        self.preparingOrderHeigh.constant = 30
        self.finishOrderHeigh.constant = 30
        self.preparingView.isHidden = true
        self.finishView.isHidden = true
    }
    
    func backTapped() {
        backButton.rx.tap.subscribe { [weak self] _ in
            saveOrderForCusomerSuccess.onNext(false)
            toggleFinishOrderView.onNext(false)
            self?.router.backAction()
        } .disposed(by: self.disposeBag)
        
    }
    
    func showPricingView() {
        saveOrderForCusomerSuccess.subscribe { [weak self] _ in
            self?.pricingViewHeigh.constant = 250
            self?.finishOrderHeigh.constant = 100
            self?.receivedORderPricingButton.isHidden = true
            self?.cancelButton.isHidden = true
            self?.acceptButton.isHidden = true
        }.disposed(by: self.disposeBag)

    }
    
    func showFinishView() {
        toggleFinishOrderView.subscribe { [weak self] _ in
            self?.preparingOrderHeigh.constant = 100
            self?.receivedORderPricingButton.isHidden = true
            self?.cancelButton.isHidden = true
            self?.acceptButton.isHidden = true
            self?.acceptPricing.isHidden = true
            self?.cancelPricing.isHidden = true
        }.disposed(by: self.disposeBag)

    }
    
    
    func finishOrder() {
        finishButton.rx.tap.subscribe { [weak self] _ in
            self?.articleDetailsViewModel.finishOrder(offerId: self?.OrderTracking?.orderID ?? 0)
        } .disposed(by: self.disposeBag)

    }
    
    func noShowButtonTapped() {
        noShow.rx.tap.subscribe { [weak self] _ in
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
    //showCancelPopViewAfterShowingBranches
    func acceptOrderAfterRemoveSubView() {
        removeSubview.subscribe { [weak self] removeSubview in
            if removeSubview.element == true {
                if showCancelPopViewAfterShowingBranches {
            self?.articleDetailsViewModel.acceptOrder(BranchID: branchSelected)
                }
                else {
                    self?.showCancelationPopView()
                }
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
                print("zxcxzc",orderTrackin)
                self?.OrderTracking = orderTrackin.element
                if let url = URL(string: baseURLImage + (orderTrackin.element?.patientProfileImage ?? "")) {
                    self?.patientImage.load(url: url)
                }
                offerPharmacyOrderId = orderTrackin.element?.currentOffer?.pharmacyOrderOfferID ?? 0
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
    
    func acceptPricingTapped(){
        acceptPricing.rx.tap.subscribe { [weak self] _  in
            self?.articleDetailsViewModel.acceptPricing(offerId: offerPharmacyOrderId )
        } .disposed(by: self.disposeBag)

    }
    func acceptTapped() {
        addBranchesAsSubviewForAccept()
    }
    
    func cancelOrderTapped() {
        addBranchesAsSubviewForCancel()
    }
    
    func showCancelationPopView() {
            let subView = UIStoryboard.init(name: Storyboards.orders.rawValue, bundle: nil).instantiateViewController(withIdentifier: ViewController.popCancelationview.rawValue)
            subView.view.frame = (self.view.bounds)
            self.view.addSubview(subView.view)
    }
    
    func subcribeToFiles() {
        articleDetailsViewModel.orderTrackingFiles.subscribe {[weak self] pharmacyFiles in
            DispatchQueue.main.async {
            if (pharmacyFiles.element?.count ?? 0) > 0 {
                self?.filesCollectionView.isHidden = false
            }
            else {
                 self?.filesCollectionView.isHidden = true
               }
            }
        } .disposed(by: self.disposeBag)
        
    }
    
    func subcribeToOrders() {
        articleDetailsViewModel.orderTrackingSummary.subscribe {[weak self] orders in
            DispatchQueue.main.async {
            if (orders.element?.count ?? 0) > 0 {
                self?.summaryTableView.isHidden = false
            }
            else {
                self?.summaryTableView.isHidden = true
               }
            }
        } .disposed(by: self.disposeBag)

    }
    
    func bindfilesToCollectionview() {
        articleDetailsViewModel.orderTrackingFiles
            .bind(to: self.filesCollectionView
                    .rx
                    .items(cellIdentifier: String(describing:  FilesCollectionViewCell.self),
                           cellType: FilesCollectionViewCell.self)) { row, model, cell in
                cell.setImage(image: model)
            }.disposed(by: self.disposeBag)
    }
    
    func addBranchesAsSubviewForAccept() {
        acceptButton.rx.tap.subscribe { [weak self] _ in
            let subView = UIStoryboard.init(name: Storyboards.orders.rawValue, bundle: nil).instantiateViewController(withIdentifier: ViewController.BranchesPopView.rawValue)
            showCancelPopViewAfterShowingBranches = true
            subView.view.frame = (self?.view.bounds)!
            self?.view.addSubview(subView.view)
        }.disposed(by: self.disposeBag)

    }
    
    func addBranchesAsSubviewForCancel() {
        cancelButton.rx.tap.subscribe { [weak self] _ in
            let subView = UIStoryboard.init(name: Storyboards.orders.rawValue, bundle: nil).instantiateViewController(withIdentifier: ViewController.BranchesPopView.rawValue)
            showCancelPopViewAfterShowingBranches = false
            subView.view.frame = (self?.view.bounds)!
            self?.view.addSubview(subView.view)
        }.disposed(by: self.disposeBag)

    }
    
    func  cancelPricingTapped() {
        cancelPricing.rx.tap.subscribe { [weak self] _ in
            let subView = UIStoryboard.init(name: Storyboards.orders.rawValue, bundle: nil).instantiateViewController(withIdentifier: ViewController.BranchesPopView.rawValue)
            showCancelPopViewAfterShowingBranches = false
            subView.view.frame = (self?.view.bounds)!
            self?.view.addSubview(subView.view)
        }.disposed(by: self.disposeBag)

    }
    
    func bindPricingMeddicineToTableView() {
        articleDetailsViewModel.orderTrackingSummary
            .bind(to: self.pricingTableView
                    .rx
                    .items(cellIdentifier: String(describing:  OrderTrackingPrcingTableViewCell.self),
                           cellType: OrderTrackingPrcingTableViewCell.self)) { row, model, cell in
                cell.medicinLabel.text = model.medicationNameLocalized
                
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
    
    func showReceivedView() {
        self.receivedViewDetails.isHidden = false
        self.receivedFlagColor.backgroundColor = .blue
        self.receivedViewHeight.constant = 100
    }
    
    func pricingButtonTapped() {
        receivedORderPricingButton.rx.tap.subscribe { [weak self] _ in
            self?.router.showPricingView(OrderTrackingModel: self?.OrderTracking)
        }.disposed(by: self.disposeBag)

    }
}

extension OrderTrackingViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
