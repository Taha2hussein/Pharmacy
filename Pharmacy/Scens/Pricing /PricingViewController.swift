//
//  PricingViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 12/03/2022.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
 var selectedMedicineArr = [Medicine]()
var selectedMedicin = PublishSubject<[Medicine]>()
var selectedMedicin_OrderItems = PublishSubject<[Medicine]>()
var orderOrice = 0
var orderInvoicePrice = 0
var totalOrderItemsPrice = PublishSubject<Int>()
var totalOrderInvoicePrice = PublishSubject<Int>()
var priceCheck = false

enum orderTypeSelected {
    case rxImage
    case medicine
}

class PricingViewController: BaseViewController {
    
    @IBOutlet weak var addNewMedicin: UIButton!
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var setTimeButton: UIButton!
    @IBOutlet weak var deiveryFeesField: UITextField!
    @IBOutlet weak var setDiscountField: UITextField!
    @IBOutlet weak var orderCost: UILabel!
    @IBOutlet weak var orderInvoiceTableView: UITableView!
    @IBOutlet weak var orderItemTableView: UITableView!
    @IBOutlet weak var pricingFilesCollectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var rxViewHeigh: NSLayoutConstraint!
    
    var totalPriceBindind = PublishSubject<String>()
    var totalPriceBindindAfterDiscount = PublishSubject<String>()

    private var totalPriceForMedicine = 0
    private var orderType : orderTypeSelected = .medicine
    var articleDetailsViewModel = PricingViewModel()
    private var router = PricingRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        addNewMedicing()
        backTapped()
        bindBranchToTableView()
        bindOrderItemsToTableview()
        saveTapped()
        articleDetailsViewModel.setup()
        subsribeToTotalOrderPrice()
        bindTotalPriceToTextField()
        subsribeToTotalInvoicePrice()
        subscribeToLoader()
        calculateTotalInvoice()
        calculateTotalItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        orderInvoicePrice = 0
        totalPriceForMedicine = 0
        orderOrice = 0
//        totalOrderInvoicePrice.onNext(0)
//        totalOrderItemsPrice.onNext(0)
    }
    
    func setTotalPrice() {
        orderCost.text = "\(orderOrice + orderInvoicePrice)" + " Egp"
    }
    
    func subsribeToTotalOrderPrice() {
        totalOrderItemsPrice.subscribe { [weak self] price in
            self?.totalPriceForMedicine += price.element ?? 0
            self?.totalPriceBindind.onNext("\(self?.totalPriceForMedicine ?? 0)")
        }.disposed(by: self.disposeBag)

    }
    
    func subsribeToTotalInvoicePrice() {
        totalOrderInvoicePrice.subscribe { [weak self] price in
            self?.totalPriceForMedicine += price.element ?? 0
            self?.totalPriceBindind.onNext("\(self?.totalPriceForMedicine ?? 0)" )
            self?.totalPriceBindindAfterDiscount.onNext(("\((self?.totalPriceForMedicine ?? 0) - (Int(self?.setDiscountField.text ?? "0") ?? 0))"))
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
    
    func bindTotalPriceToTextField() {

        totalPriceBindind
                    .bind(to: self.orderCost.rx.text).disposed(by: self.disposeBag)
        totalPriceBindindAfterDiscount .bind(to: self.totalCost.rx.text).disposed(by: self.disposeBag)
        
    }
    
    func bindOrderItemsToTableview() {
        selectedMedicin
            .bind(to: self.orderInvoiceTableView
                    .rx
                    .items(cellIdentifier: String(describing:  OrderInvoiceTableViewCell.self),
                           cellType: OrderInvoiceTableViewCell.self)) { row, model, cell in
                cell.setData( orderInvoice: model)
            }.disposed(by: self.disposeBag)
    }

    func bindBranchToTableView() {
        articleDetailsViewModel.orderItems
            .bind(to: self.orderItemTableView
                    .rx
                    .items(cellIdentifier: String(describing:  OrderItemsTableViewCell.self),
                           cellType: OrderItemsTableViewCell.self)) {[weak self] row, model, cell in
                cell.setOrderItems(orderItem: model)
                cell.medicinAlternativ.rx.tap.subscribe { [weak self] _ in
                    self?.orderType = .medicine
                    self?.router.addNewMedicingView(orderType: self!.orderType , MedicinCategoryId:  model.medicineCategoryFk ?? 0, MedicineType: model.medicineType ?? 0)
                } .disposed(by: cell.bag)
            }.disposed(by: self.disposeBag)
    }
    
    
    // ccalaucate orderInvoice
    func calculateTotalInvoice() {
        selectedMedicin.subscribe { selectedValue in
            let calue = selectedValue.element
            let total = calue?.map({$0.price ?? 0}).reduce(0, +)
            totalOrderInvoicePrice.onNext(total ?? 0)
        } .disposed(by: self.disposeBag)

    }
    
    func calculateTotalItems() {
        articleDetailsViewModel.orderItems.subscribe { selectedValue in
            let calue = selectedValue.element
            let total = calue?.map({$0.itemFees ?? 0}).reduce(0, +)
            totalOrderItemsPrice.onNext(Int(total ?? 0.0))
        } .disposed(by: self.disposeBag)

    }
    
    
    func addNewMedicing() {
        addNewMedicin.rx.tap.subscribe { [weak self] _ in
            self?.orderType = .rxImage
            
            self?.router.addNewMedicingView(orderType: self!.orderType,MedicinCategoryId:  0, MedicineType: 0)
        }.disposed(by: self.disposeBag)
        
    }
    
    func saveTapped(){
        saveButton.rx.tap.subscribe { [weak self] _ in
            let discount = Double(self?.setDiscountField.text ?? "0.0")
            self?.articleDetailsViewModel.saveDataToCustomer(alternativeMedicine: selectedMedicineArr,discount: discount ?? 0.0)
        } .disposed(by: self.disposeBag)

    }
    
    func backTapped() {
        backButton.rx.tap.subscribe { [weak self] _ in
            self?.router.backAction()
        }.disposed(by: self.disposeBag)
        
    }
}

extension PricingViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}

extension PricingViewController: UICollectionViewDataSource , UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articleDetailsViewModel.OrderTrackingMessage?.pharmacyOrderFile?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PricingFilesCollectionViewCell", for: indexPath)as! PricingFilesCollectionViewCell
        cell.setImage(image: articleDetailsViewModel.OrderTrackingMessage?.pharmacyOrderFile?[indexPath.item].filePath ?? "")
        return cell
    }
}
