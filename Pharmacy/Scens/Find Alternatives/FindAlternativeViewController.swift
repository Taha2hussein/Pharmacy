//
//  FindAlternativeViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 13/03/2022.
//

import UIKit
import RxCocoa
import RxRelay
import RxSwift

class FindAlternativeViewController: BaseViewController {
    
    @IBAction func searchMdeicin(_ sender: Any) {
        if  let searchText  =  MedicineFilterTextField.text  {
            
            guard let sections = try? articleDetailsViewModel.Medicine.value() else { return  }
            guard let sectionsTem = try? articleDetailsViewModel.tembMedcine.value() else { return  }
            
          
                var filterArr = (sections.filter({(($0.nameLocalized!).localizedCaseInsensitiveContains(searchText))}))
                
                if filterArr.count > 0 {
                    articleDetailsViewModel.Medicine.onNext(filterArr)
                }
                else {
                    filterArr.removeAll()
                    articleDetailsViewModel.Medicine.onNext(filterArr)
                    showToast(LocalizedStrings().emptySearchData)
                }
            if searchText == "" {
                filterArr.removeAll()
                articleDetailsViewModel.Medicine.onNext(sectionsTem)
            }
            self.medicinTableView.reloadData()
        }
    }
    
    @IBOutlet weak var MedicineFilterTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var medicinTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    private var pricingViewMod = PricingViewModel()
    var articleDetailsViewModel = FindAlternativeViewModel()
    private var router = FindAlternativeRouter()
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        subscribeToLoader()
        bindBranchToTableView()
        intializeTableViewHeight()
        backButtonTapped()
        filterTapped()
        searchButtonTapped()
        saveAction()
        configureSearch()
        //        validateEmptyMedicine()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setup()
        selectedMedicin.onNext([])
    }
    
    
    func setup() {
        
        if articleDetailsViewModel.orderType == .medicine {
            self.filterView.isHidden = true
            articleDetailsViewModel.getAlternative()
        }
        else {
            self.filterView.isHidden = false
            articleDetailsViewModel.getAllMdeicine()
        }
    }
    
    func searchButtonTapped() {
        searchButton.rx.tap.subscribe { [weak self] _ in
            
            self?.setup()
        }.disposed(by: self.disposeBag)
    }
    
    func intializeTableViewHeight() {
        self.medicinTableView.rowHeight = 120
    }
    
    func backButtonTapped(){
        backButton.rx.tap.subscribe { [weak self] _ in
            selectedMedicin.onNext(selectedMedicineArr)
            self?.router.backAction()
        }.disposed(by: self.disposeBag)
        
    }
    
    func saveAction() {
        saveButton.rx.tap.subscribe { [weak self] _ in
            selectedMedicin.onNext(selectedMedicineArr)
            self?.router.backAction()
        } .disposed(by: self.disposeBag)
        
    }
    
    fileprivate func configureSearch() {
        
        
    }
    
    //    func validateEmptyMedicine() {
    //        articleDetailsViewModel.Medicine.subscribe { [weak self] medicine in
    //            if (medicine.element?.count ?? 0) > 0 {
    //
    //            }
    //            else {
    //                showToast(LocalizedStrings().emptySearchData)
    //            }
    //        }.disposed(by: self.disposeBag)
    //
    //    }
    
    func bindBranchToTableView() {
        articleDetailsViewModel.Medicine
            .bind(to: self.medicinTableView
                .rx
                .items(cellIdentifier: String(describing:  FindAlternativeTableViewCell.self),
                       cellType: FindAlternativeTableViewCell.self)) {[weak self] row, model, cell in
                
                if self?.articleDetailsViewModel.orderType == .rxImage {
//                    guard let medicineSelectedPrevios = try? selectedMedicin.value() else { return }
                    cell.setDateForSelectedMedicineForRXImage(medicine: model,selectedMedicine: selectedMedicineArr,index: row)
                    cell.addMedicinButton.rx.tap.subscribe { _ in
                        selectedMedicineArr.append(model)
                        cell.removeMedicine.isHidden = false
                        cell.addMedicinButton.isHidden = true
                    } .disposed(by: cell.bag)
                    
                    cell.removeMedicine.rx.tap.subscribe {  _ in
                        cell.removeMedicine.isHidden = true
                        cell.addMedicinButton.isHidden = false
                        if let index = selectedMedicineArr.firstIndex(where: {$0.medicationID == model.medicationID}){
                            selectedMedicineArr.remove(at: index)
                        }
                    } .disposed(by: cell.bag)
                }
                
                else {
                    cell.setData(medicine: model)
                    cell.addMedicinButton.rx.tap.subscribe { _ in
                        let alternativeOrderitem = OrderTrackingPharmacyOrderItem(pharmacyOrderItemID: model.medicationID, medicationFk: model.medicationID, itemFees: model.price, medicationNameLocalized: model.nameLocalized, priceType: model.priceType, medicineCategoryFk: model.medicineCategoryFk, medicineType: model.medicineType, quantity: 1, isAlternative: true, strenghtValue: "\(model.strenghtValue ?? 0)", medicineTypeNameLocalized: model.medicineTypeNameLocalized, strenghtNameLocalized: model.medicineTypeNameLocalized, formNameLocalized: model.medicineForm, amountDetailsLocalized: model.medicineAmountDetailsLocalizeds, prescriptionData:  nil)
                        
                        alternativeOrderitems = alternativeOrderitem
                        orderItemAlternativeCheck = .addMedicine
                        cell.removeMedicine.isHidden = false
                        cell.addMedicinButton.isHidden = true
                        self?.router.backAction()
                    } .disposed(by: cell.bag)
                    
                    cell.removeMedicine.rx.tap.subscribe {  _ in
                        
                        cell.removeMedicine.isHidden = true
                        cell.addMedicinButton.isHidden = false
                        alternativeMedcineRemovedIndex = model.medicationID ?? 0
                        orderItemAlternativeCheck = .removeMedicine
                        
                    } .disposed(by: cell.bag)
                    
                }
            }.disposed(by: self.disposeBag)
    }
    
    func filterTapped() {
        filterButton.rx.tap.subscribe { [weak self] _ in
            self?.router.showFilterView(MedicinCategoryId: self?.articleDetailsViewModel.MedicinCategoryId ?? 0)
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
extension FindAlternativeViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
