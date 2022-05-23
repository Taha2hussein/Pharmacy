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
import SDWebImage
//var offerPharmacyOrderId : Int?
var orderId = Int()
var toggleFinishOrderView = PublishSubject<Bool>()
var receivedAcceptedNotificationFromPatient = PublishSubject<Int>()
class OrderTrackingViewController: BaseViewController {
    
    // received
    @IBOutlet weak var receivedViewHeight: NSLayoutConstraint!
    @IBOutlet weak var receivedFlagColor: UIView!
    @IBOutlet weak var receivedViewDetails: UIView!
    @IBOutlet weak var receivedOrderLabel: UILabel!
    @IBOutlet weak var receivedORderPricingButton: UIButton!
    
//    @IBOutlet weak var filesCollectionViewHeigh: NSLayoutConstraint!
    @IBOutlet weak var summaryTableViewHeigh: NSLayoutConstraint!
    @IBOutlet weak var orderLocation: UILabel!
    @IBOutlet weak var editpricingButton: UIButton!
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
    @IBOutlet weak var preparingFlagView: UIView!
    
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var deliveryFees: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var orderCost: UILabel!
    
    @IBOutlet weak var deliveredFlagView: UIView!
    @IBOutlet weak var pricingFlagView: UIView!
    @IBOutlet weak var deliveredOrderLabel: UILabel!
    @IBOutlet weak var preparingOrderLabel: UILabel!
    @IBOutlet weak var pricingOrderLabel: UILabel!
    
    @IBOutlet weak var pricingTime: UILabel!
    @IBOutlet weak var deliveredTime: UILabel!
    @IBOutlet weak var preparingOrderTime: UILabel!
    @IBOutlet weak var recivedTextLabel: UILabel!
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var newOrderDate: UILabel!
    @IBOutlet weak var preparingOrderHeigh: NSLayoutConstraint!
    
//    @IBOutlet weak var neworderHeight: NSLayoutConstraint!
    @IBOutlet weak var preparingView: UIView!
    @IBOutlet weak var finishView: UIView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var noShow: UIButton!
    @IBOutlet weak var finishOrderHeigh: NSLayoutConstraint!
    
    @IBOutlet weak var newOrderHeight: NSLayoutConstraint!
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
        bindCurrentOffer()
        showFinishView()
        finishOrder()
        //        showFinishViewDirectly()
        validateViewFromNeedAction()
        editPricingAction()
        listenToNotification()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        articleDetailsViewModel.getOrderTracking()
        selectedMedicin.onNext([])
        selectedMedicineArr.removeAll()
        
        //        totalOrderItemsPrice.onNext(0.0)
        //        totalOrderInvoicePrice.onNext(0.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationIdentifier"), object: nil)
    }
    
    func validateViewFromNeedAction() {
        if articleDetailsViewModel.singleOrderStatus == 0 {
            
        }
        
        else if articleDetailsViewModel.singleOrderStatus == 1 {
            cancelButton.isHidden = true
            acceptButton.isHidden = true
//            neworderHeight.constant = 0
            showReceivedView()
        }
        
        else if articleDetailsViewModel.singleOrderStatus == 2 {
            showPrcingDirectDependonStatus()
        }
        
       else if articleDetailsViewModel.singleOrderStatus == 4 {
            showUnCompleteView()
            preparingOrderHeigh.constant = 100
            receivedViewHeight.constant = 100
            preparingView.isHidden = false
            finishView.isHidden = false
        }
        
        else if articleDetailsViewModel.singleOrderStatus == 3 {
            showUnCompleteView()
            preparingOrderHeigh.constant = 30
            receivedViewHeight.constant = 30
            editpricingButton.isHidden = true
            newOrderHeight.constant = 30
            receivedFlagColor.backgroundColor = .blue
            receivedFlagColor.backgroundColor = .blue
            pricingFlagView.backgroundColor = .blue
        }
    }
    
    func showFinishViewDirectly() {
        if orderSelected == .upcoming {
            if articleDetailsViewModel.singleOrderStatus == 4 {
                showUnCompleteView()
                preparingView.isHidden = false
                finishView.isHidden = false
            }
            else if articleDetailsViewModel.singleOrderStatus == 3 {
                showUnCompleteView()
            }
        }
    }
    
    func showUnCompleteView() {
        receivedORderPricingButton.isHidden = true
        cancelButton.isHidden = true
        acceptButton.isHidden = true
        acceptPricing.isHidden = true
        cancelPricing.isHidden = true
        pricingViewHeigh.constant = 294
        finishOrderHeigh.constant = 100
        
    }
    
    func showPrcingDirectDependonStatus() {
        receivedORderPricingButton.isHidden = true
        cancelButton.isHidden = true
        acceptButton.isHidden = true
        acceptPricing.isHidden = false
        cancelPricing.isHidden = false
        pricingViewHeigh.constant = 294
        finishOrderHeigh.constant = 100
        newOrderHeight.constant = 30
        receivedFlagColor.backgroundColor = .blue
        pricingFlagView.backgroundColor = .blue
    }
    
    func setup() {
        self.receivedViewHeight.constant = 30
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
            self?.pricingViewHeigh.constant = 294
            self?.finishOrderHeigh.constant = 100
            self?.receivedViewHeight.constant = 30
//            self?.neworderHeight.constant = 0
            
            self?.newOrderHeight.constant = 30
            self?.receivedFlagColor.backgroundColor = .blue
            self?.pricingFlagView.backgroundColor = .blue
            self?.receivedORderPricingButton.isHidden = true
            self?.cancelButton.isHidden = true
            self?.acceptButton.isHidden = true
            self?.pricingFlagView.backgroundColor = .blue
            self?.pricingOrderLabel.textColor = .blue
//            self?.editpricingButton.isHidden = true
        }.disposed(by: self.disposeBag)
        
    }
    
    func listenToNotification() {
        print("dsdsss")
        receivedAcceptedNotificationFromPatient.subscribe { [weak self] notificationOrderID in
            //            if notificationOrderID.element == self?.OrderTracking?.orderID {
            self?.receivedORderPricingButton.isHidden = true
            self?.cancelButton.isHidden = true
            self?.acceptButton.isHidden = true
            self?.acceptPricing.isHidden = true
            self?.cancelPricing.isHidden = true
            self?.pricingViewHeigh.constant = 294
            self?.finishOrderHeigh.constant = 100
            self?.preparingOrderHeigh.constant = 100
            self?.receivedViewHeight.constant = 100
            self?.preparingView.isHidden = false
            self?.finishView.isHidden = false
            //            }
        }.disposed(by: self.disposeBag)
        
    }
    
    //    @objc func showSpinningWheel(_ notification: NSNotification) {
    //
    //      if let order = notification.userInfo?["order"] as? Int {
    //          print("notificationobserver",order)
    //          if order == self.OrderTracking?.orderID {
    //              receivedORderPricingButton.isHidden = true
    //               cancelButton.isHidden = true
    //               acceptButton.isHidden = true
    //               acceptPricing.isHidden = true
    //               cancelPricing.isHidden = true
    //               pricingViewHeigh.constant = 250
    //               finishOrderHeigh.constant = 100
    //               preparingOrderHeigh.constant = 100
    //               receivedViewHeight.constant = 100
    //               preparingView.isHidden = false
    //               finishView.isHidden = false
    //          }
    //        }
    //     }
    
    
    
    func showFinishView() {
        toggleFinishOrderView.subscribe { [weak self] _ in
            self?.showFinishOrder()
        }.disposed(by: self.disposeBag)
        
    }
    
    func showFinishOrder() {
        self.preparingOrderHeigh.constant = 100
        self.receivedORderPricingButton.isHidden = true
        self.cancelButton.isHidden = true
        self.acceptButton.isHidden = true
        self.acceptPricing.isHidden = true
        self.cancelPricing.isHidden = true
        self.deliveredFlagView.borderColor = .blue
        self.deliveredOrderLabel.textColor = .blue
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
    
    func editPricingAction() {
        
        editpricingButton.rx.tap.subscribe { [weak self] _ in
            self?.router.showPricingView(OrderTrackingModel: self?.OrderTracking)
        }.disposed(by: self.disposeBag)
        
    }
    
    func CancelOrderAfterRemoveSubView() {
        cancelRemoveSubview.subscribe { [weak self] cancelRemove in
            if cancelRemove.element == true {
                self?.articleDetailsViewModel.cancelOrder(BranchID: branchSelected)
            }
        } .disposed(by: self.disposeBag)
        
    }
    
//    func selectMedicineToShowBige() {
//        Observable.zip(filesCollectionView
//            .rx
//            .itemSelected,filesCollectionView.rx.modelSelected(PharmacyOrderFile.self)).bind { [weak self] selectedIndex, product in
//                
////                self?.articleDetailsViewModel.showDetailsBranch(source: product , previosView: .pharmacy)
//            }.disposed(by: self.disposeBag)
//    }
//    
    func imageTapped(image:UIImage){
        let newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .gray.withAlphaComponent(0.5)
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
//        self.navigationController?.isNavigationBarHidden = true
//        self.tabBarController?.tabBar.isHidden = true
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
//        self.navigationController?.isNavigationBarHidden = false
//        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
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
//                    self?.patientImage.load(url: url)
                    self?.patientImage.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar"))

                }
                //                offerPharmacyOrderId = orderTrackin.element?.currentOffer?.pharmacyOrderOfferID ?? 0
                
                singlton.shared.pharmacyOfferId = orderTrackin.element?.currentOffer?.pharmacyOrderOfferID ?? 0
                orderId = orderTrackin.element?.orderID ?? 0
                self?.patientName.text = orderTrackin.element?.patientName
                self?.patientNumber.text = "\(orderTrackin.element?.patientID ?? 0)"
                self?.patientGender.text = (orderTrackin.element?.patientGender == 1) ? "Male" : "Female"
                self?.patientName.text = ( "Wt: " + "\(orderTrackin.element?.patientWeight ?? 0)" + "Kg, Ht: "  + "\(orderTrackin.element?.patientHeight ?? 0)" + "cm")
                self?.patitientEmail.text = orderTrackin.element?.patientEmail
                self?.patientName.text = orderTrackin.element?.patientName
                self?.patientPhone.text = orderTrackin.element?.patientMobile
                self?.patientCode.text = orderTrackin.element?.orderNo
                self?.orderLocation.text = orderTrackin.element?.patientAddressLocalized
                if let convertedDate = convertDateFormat(inputDate: orderTrackin.element?.orderDate ?? "")as? String {
                    self?.orderDate.text = convertedDate
                    self?.newOrderDate.text = convertedDate
                    self?.preparingOrderTime.text = convertedDate
                    self?.deliveredTime.text = convertedDate
                    self?.pricingTime.text = convertedDate
                }
                self?.orderPayment.text = orderTrackin.element?.paymentTypeLocalized
                self?.orderType.text = orderTrackin.element?.orderType
                self?.orderNotes.text =  orderTrackin.element?.orderNotes
            }
        } .disposed(by: self.disposeBag)
    }
    
    func acceptPricingTapped(){
        acceptPricing.rx.tap.subscribe { [weak self] _  in
            self?.articleDetailsViewModel.acceptPricing(offerId: singlton.shared.pharmacyOfferId  )
        } .disposed(by: self.disposeBag)
        
    }
    
    func hidePricingButtons() {
        acceptPricing.isHidden = true
        cancelPricing.isHidden = true
        editpricingButton.isHidden = true
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
//                    self?.filesCollectionViewHeigh.constant = 145
                }
                else {
                    
                    self?.filesCollectionView.isHidden = true
//                    self?.filesCollectionViewHeigh.constant = 0
                }
            }
        } .disposed(by: self.disposeBag)
        
    }
    
    func subcribeToOrders() {
        articleDetailsViewModel.orderTrackingSummary.subscribe {[weak self] orders in
            DispatchQueue.main.async {
                if (orders.element?.count ?? 0) > 0 {
                    self?.summaryTableView.isHidden = false
//                    self?.neworderHeight.constant = 200
//                    self?.summaryTableViewHeigh.constant = 145
//                    self?.summaryTableView.rowHeight = CGFloat(((orders.element?.count ?? 0) * 10))
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
                
                cell.medicineButtonImage.rx.tap.subscribe { [weak self] _ in
                    self?.imageTapped(image: cell.medicineButtonImage.imageView?.image ?? UIImage())
                }.disposed(by: self.disposeBag)

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
            self?.showCancelationPopView()
//            let subView = UIStoryboard.init(name: Storyboards.orders.rawValue, bundle: nil).instantiateViewController(withIdentifier: ViewController.BranchesPopView.rawValue)
//            showCancelPopViewAfterShowingBranches = false
//            subView.view.frame = (self?.view.bounds)!
//            self?.view.addSubview(subView.view)
        }.disposed(by: self.disposeBag)
        
    }
    
    func  cancelPricingTapped() {
        cancelPricing.rx.tap.subscribe { [weak self] _ in
            self?.showCancelationPopView()
//            let subView = UIStoryboard.init(name: Storyboards.orders.rawValue, bundle: nil).instantiateViewController(withIdentifier: ViewController.BranchesPopView.rawValue)
//            showCancelPopViewAfterShowingBranches = false
//            subView.view.frame = (self?.view.bounds)!
//            self?.view.addSubview(subView.view)
        }.disposed(by: self.disposeBag)
        
    }
    
    func bindCurrentOffer() {
        articleDetailsViewModel.currentOffer.subscribe { [weak self] CurrentOffers in
            if let currentOffer = CurrentOffers.element {
                DispatchQueue.main.async {
            self?.orderCost.text = "\(currentOffer?.orderFees ?? 0)"
                self?.discount.text = "\(currentOffer?.orderDiscount ?? 0)"
            self?.deliveryFees.text = "\(currentOffer?.deliveryFees ?? 0)"
            self?.totalCost.text = "\(currentOffer?.orderTotalFees ?? 0)"
                }
                
            }
        }.disposed(by: self.disposeBag)

    }
    func bindPricingMeddicineToTableView() {
        articleDetailsViewModel.offerPricing
            .bind(to: self.pricingTableView
                .rx
                .items(cellIdentifier: String(describing:  OrderTrackingPrcingTableViewCell.self),
                       cellType: OrderTrackingPrcingTableViewCell.self)) { row, model, cell in
                cell.setData(orderItem: model)
            }.disposed(by: self.disposeBag)
    }
    
    func bindBranchToTableView() {
        articleDetailsViewModel.orderTrackingSummary
            .bind(to: self.summaryTableView
                .rx
                .items(cellIdentifier: String(describing:  OrderTrackingTableViewCell.self),
                       cellType: OrderTrackingTableViewCell.self)) { row, model, cell in
                cell.summaryLabel.text = "\(model.quantity ?? 0) x " + (model.medicationNameLocalized ?? "")
                
            }.disposed(by: self.disposeBag)
    }
    
    func showReceivedView() {
        self.receivedViewDetails.isHidden = false
        self.receivedFlagColor.backgroundColor = .blue
        self.receivedOrderLabel.textColor = .blue
        self.receivedViewHeight.constant = 100
        self.acceptButton.isHidden = true
        self.cancelButton.isHidden = true
//        self.orderView.isHidden = true
        self.recivedTextLabel.textColor = .blue
//        self.neworderHeight.constant = 0
        self.newOrderDate.isHidden = true
        self.newOrderHeight.constant = 30.0
//        self.view.layoutIfNeeded()
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
