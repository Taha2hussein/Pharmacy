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
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var searchMdeicin: UITextField!
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setup()
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
            self?.router.backAction()
        }.disposed(by: self.disposeBag)

    }
    
    func saveAction() {
        saveButton.rx.tap.subscribe { [weak self] _ in
            selectedMedicin.onNext(selectedMedicineArr)
            self?.router.backAction()
        } .disposed(by: self.disposeBag)

    }
    
    func bindBranchToTableView() {
        articleDetailsViewModel.Medicine
            .bind(to: self.medicinTableView
                    .rx
                    .items(cellIdentifier: String(describing:  FindAlternativeTableViewCell.self),
                           cellType: FindAlternativeTableViewCell.self)) { row, model, cell in
                cell.setData(medicine: model)
                if self.articleDetailsViewModel.orderType == .rxImage {
                    cell.addMedicinButton.rx.tap.subscribe { [weak self] _ in
                     selectedMedicineArr.append(model)
                    } .disposed(by: self.disposeBag)

                }
                
                else {
               
//                    pricingViewMod.orderItems.onNext(model)
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
