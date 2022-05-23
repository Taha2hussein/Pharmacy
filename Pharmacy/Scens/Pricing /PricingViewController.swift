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
import SDWebImage
var selectedMedicineArr = [Medicine]()
var selectedMedicin = BehaviorSubject<[Medicine]>(value: [])
var selectedMedicin_OrderItems = PublishSubject<[Medicine]>()
var selectMedcineToBeAlternative = Int()
//var validateQuantityForInvoice = PublishSubject<Double>()
//var validatePriceForInvoice = PublishSubject<Double>()
enum orderItemAlternative {
    case addMedicine
    case removeMedicine
    case defaul
}
var orderItemAlternativeCheck: orderItemAlternative = .defaul
var alternativeOrderitems : OrderTrackingPharmacyOrderItem?
var alternativeMedcineRemovedIndex = Int()
var priceCheck = false

enum orderTypeSelected {
    case rxImage
    case medicine
}

class PricingViewController: BaseViewController {
    
    @IBOutlet weak var setTimeView: UIView!
    @IBOutlet weak var deliveryFeesView: UIView!
    @IBOutlet weak var orderItemHeight: NSLayoutConstraint!
    @IBOutlet weak var orderImteView: UIView!
    @IBOutlet weak var addOrderInvoiceHeight: NSLayoutConstraint!
    @IBOutlet weak var addOrderInvoiceView: UIView!
    @IBOutlet weak var rxImageView: UIView!
    @IBOutlet weak var addNewMedicin: UIButton!
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var setTimeButton: UIButton!
    @IBOutlet weak var deiveryFeesField: UITextField!
    @IBOutlet weak var setDiscountField: UITextField!{ didSet { setDiscountField.delegate = self } }
    @IBOutlet weak var orderCost: UILabel!
    @IBOutlet weak var orderInvoiceTableView: UITableView!
    @IBOutlet weak var orderItemTableView: UITableView!
    @IBOutlet weak var pricingFilesCollectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var rxViewHeigh: NSLayoutConstraint!
    
    var totalPriceBindind = BehaviorSubject<String>(value: "0")
    var totalPriceBindindAfterDiscount = PublishSubject<String>()
    
    private var calculationPrice = 0
    var totalPriceForMedicine = BehaviorRelay<Int>(value: 0)
    private var orderType : orderTypeSelected = .medicine
    var articleDetailsViewModel = PricingViewModel()
    private var router = PricingRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toogleOrderView()
        bindViewControllerRouter()
        addNewMedicing()
        backTapped()
        bindBranchToTableView()
        bindOrderItemsToTableview()
        bindDiscountLabel()
        saveTapped()
        bindTotalPriceToTextField()
        subscribeToLoader()
        calculateTotalInvoice()
        setTimeAction()
        calculateTotalItems()
        articleDetailsViewModel.setup()
        listenToPrice()
        checkDeliveryFeesView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CompanyId =  false
        //totalPriceForMedicine
        selectedMedicin.onNext(selectedMedicineArr)
        if orderItemAlternativeCheck == .addMedicine {
            guard var orderitem = try? articleDetailsViewModel.orderItems.value() else { return }

            if let order = alternativeOrderitems {
                if (orderitem[selectMedcineToBeAlternative].isAlternative == true){
                    if let idnex = orderitem.firstIndex(where: {$0.medicationFk == order.medicationFk}) {
                        orderitem.remove(at: selectMedcineToBeAlternative)
                        orderitem[idnex].isAlternative = nil
                        orderitem[idnex].itemFees = order.itemFees
                    }
                    else {
                    orderitem.insert(order, at: selectMedcineToBeAlternative + 1)
                    orderitem[selectMedcineToBeAlternative].isAlternative = false
                    orderitem[selectMedcineToBeAlternative].itemFees = 0.0
                    }
                }
                else {
                orderitem.insert(order, at: selectMedcineToBeAlternative + 1)
                orderitem[selectMedcineToBeAlternative].isAlternative = false
                orderitem[selectMedcineToBeAlternative].itemFees = 0.0
                }
                articleDetailsViewModel.orderItems.onNext(orderitem)
                orderItemAlternativeCheck = .defaul
            }
        }
        else if orderItemAlternativeCheck == .removeMedicine{
            guard var orderitem = try? articleDetailsViewModel.orderItems.value() else { return }
            if let _ = alternativeOrderitems {
                if let index = selectedMedicineArr.firstIndex(where: {$0.medicationID == alternativeMedcineRemovedIndex}){
                    orderitem.remove(at: index)
                }

                articleDetailsViewModel.orderItems.onNext(orderitem)
                orderItemAlternativeCheck = .defaul
            }
        }
       
        calculatePrice()
    }
    
    func checkDeliveryFeesView() {
        if articleDetailsViewModel.OrderTrackingMessage?.hasDelivery ?? true {
            self.deliveryFeesView.isHidden = false
            self.setTimeView.isHidden = false
        }
        else {
            self.deliveryFeesView.isHidden = true
            self.setTimeView.isHidden = true

        }
        self.setDiscountField.text = "\(articleDetailsViewModel.OrderTrackingMessage?.currentOffer?.orderDiscount ?? 0.0 )"
        self.deiveryFeesField.text = "\(articleDetailsViewModel.OrderTrackingMessage?.currentOffer?.deliveryFees ?? 0.0 )"
        
        
    }
    
    func setTimeAction() {
        setTimeButton.rx.tap.subscribe { [weak self] _ in
            self?.showPreparingOrderView()
        } .disposed(by: self.disposeBag)

    }
    
    func showPreparingOrderView() {
        let subView = UIStoryboard.init(name: Storyboards.Pricing.rawValue, bundle: nil).instantiateViewController(withIdentifier: ViewController.PreparingOrderViewController.rawValue)
        subView.view.frame = (self.view.bounds)
        self.view.addSubview(subView.view)
    }
    
    func listenToPrice() {
        totalPriceForMedicine.subscribe {[weak self] price in
            self?.orderCost.text = "\(price.element ?? 0)"
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
    
    func calculatePriceAfterAlternative() {
        defer{
            totalPriceBindindAfterDiscount.onNext(("\((Int(self.totalPriceForMedicine.value ) ) - (Int(setDiscountField.text ?? "0") ?? 0))"))
        }
        self.calculationPrice = 0
        self.totalPriceForMedicine.accept(0)
        self.calculateTotalInvoice()
    }
    
    func calculatePrice() {
        defer{
            totalPriceBindindAfterDiscount.onNext(("\((Int(self.totalPriceForMedicine.value ) ) - (Int(setDiscountField.text ?? "0") ?? 0))"))
        }
        self.calculationPrice = 0
        self.totalPriceForMedicine.accept(0)
        self.calculateTotalInvoice()
        self.calculateTotalItems()
        
    }
    
    func bindOrderItemsToTableview() {
        selectedMedicin
            .bind(to: self.orderInvoiceTableView
                .rx
                .items(cellIdentifier: String(describing:  OrderInvoiceTableViewCell.self),
                       cellType: OrderInvoiceTableViewCell.self)) {[weak self] row, model, cell in
                cell.setData( orderInvoice: model)
               
                
                // Delete order invoice
                cell.invoiceOrderDeletion.rx.tap.subscribe {  _ in
                    guard var sections = try? selectedMedicin.value() else { return }
                    
                    sections.remove(at: row)
                    selectedMedicin.onNext(sections)
                    selectedMedicineArr.remove(at: row)
                    self?.calculatePrice()
                } .disposed(by: cell.bag)
                
                cell.changePriceCompletionHandler = {[weak self](price) in
                    print(price,"sssprice")
//                    guard var sections = try? selectedMedicin.value() else { return }
                    selectedMedicineArr[row].price = price
//                    sections.remove(at: row)
                    selectedMedicin.onNext(selectedMedicineArr)
                    self?.calculatePrice()
                }
                
                cell.changeQuantityCompletionHandler = {[weak self] (quantity) in
                    if quantity < 1 {
                        Alert().displayError(text: LocalizedStrings().quanitityError, viewController: self!)
                    }
                    else {
//                    guard var sections = try? selectedMedicin.value() else { return }
                        selectedMedicineArr[row].medicineAmountDetailsLocalizeds = "\(quantity)"
//                    sections.remove(at: row)
                    selectedMedicin.onNext(selectedMedicineArr)
                    self?.calculatePrice()
                    }
                }
                
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
                    selectMedcineToBeAlternative = row
                    self?.router.addNewMedicingView(orderType: self!.orderType , MedicinCategoryId:  model.medicineCategoryFk ?? 0, MedicineType: model.medicineType ?? 0)
                } .disposed(by: cell.bag)
            }.disposed(by: self.disposeBag)
    }
    
    
    // ccalaucate orderInvoice
    func calculateTotalInvoice() {
        selectedMedicin.subscribe {[weak self] selectedValue in
            let calue = selectedValue.element
            let total = calue?.map({$0.price ?? 0.0}).reduce(0.0, +)
            self?.calculationPrice = (self?.calculationPrice ?? 0) + Int(total ?? 0.0)
            self?.totalPriceForMedicine.accept(Int(self!.calculationPrice ))
        } .disposed(by: self.disposeBag)
        
    }
    
    func toogleOrderView() {
        articleDetailsViewModel.orderItems.subscribe {[weak self] orderItems in
            if (orderItems.element?.count ?? 0) > 0 {
                self?.orderItemHeight.constant = 215
                self?.orderImteView.isHidden = false
            }
            else {
                self?.orderItemHeight.constant = 0
                self?.orderImteView.isHidden = true
            }
            
        }.disposed(by: self.disposeBag)

    }
    
    func calculateTotalItems() {
        articleDetailsViewModel.orderItems.subscribe {[weak self] selectedValue in
            let calue = selectedValue.element
            let total = calue?.map({$0.itemFees ?? 0.0}).reduce(0.0, +)
            self?.calculationPrice = (self?.calculationPrice ?? 0) + Int(total ?? 0.0)
            self?.totalPriceForMedicine.accept(Int(self!.calculationPrice ))
        } .disposed(by: self.disposeBag)
        
    }
    
    func bindDiscountLabel() {
        setDiscountField.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.discount)
            .disposed(by: self.disposeBag)
    }
    
    func addNewMedicing() {
        addNewMedicin.rx.tap.subscribe { [weak self] _ in
            self?.orderType = .rxImage
            
            self?.router.addNewMedicingView(orderType: self!.orderType,MedicinCategoryId:  0, MedicineType: 0)
        }.disposed(by: self.disposeBag)
        
    }
    
    func validateTotalCost() {
        if let totalCost: Int = Int(self.totalCost.text ?? "0") {
            if totalCost < 0 {
                Alert().displayError(text: LocalizedStrings().totalCostError, viewController: self)
            }
            else {
                let discount = Double(self.setDiscountField.text ?? "0.0")
                let orderFees = Double(self.orderCost.text ?? "0.0")
                guard let orderitem = try? self.articleDetailsViewModel.orderItems.value() else { return }
            self.articleDetailsViewModel.saveDataToCustomer(alternativeMedicine: selectedMedicineArr,ordersMedicind:orderitem,discount: discount ?? 0.0,orderFees:orderFees ?? 0.0)
            }
        }
    }
    
    func saveTapped() {
        saveButton.rx.tap.subscribe { [weak self] _ in
          
            self?.validateTotalCost()

        } .disposed(by: self.disposeBag)
        
    }
    
    func backTapped() {
        backButton.rx.tap.subscribe { [weak self] _ in
            self?.router.backAction()
        }.disposed(by: self.disposeBag)
        
    }
    
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
//        self.navigationController?.isNavigationBarHidden = true
//        self.tabBarController?.tabBar.isHidden = true
        sender.view?.removeFromSuperview()
    }
}

extension PricingViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
//rxImageView
extension PricingViewController: UICollectionViewDataSource , UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if articleDetailsViewModel.OrderTrackingMessage?.pharmacyOrderFile?.count == 0 {
            rxImageView.isHidden = true
            rxViewHeigh.constant = 0
            addOrderInvoiceHeight.constant = 0
            addOrderInvoiceView.isHidden = true
            return 0
        }
        return articleDetailsViewModel.OrderTrackingMessage?.pharmacyOrderFile?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PricingFilesCollectionViewCell", for: indexPath)as! PricingFilesCollectionViewCell
        cell.setImage(image: articleDetailsViewModel.OrderTrackingMessage?.pharmacyOrderFile?[indexPath.item].filePath ?? "")
        
        cell.selectFile = {
            self.imageTapped(image: cell.pricingFileButton.imageView?.image ?? UIImage())
        }
        return cell
    }
    
 
}

extension PricingViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
                
        totalPriceBindindAfterDiscount.onNext(("\((Int(self.totalPriceForMedicine.value ) ) - (Int(textField.text ?? "0") ?? 0))"))
    }

}
//(Int(self.orderCost.text ?? "0") ?? 0 )
