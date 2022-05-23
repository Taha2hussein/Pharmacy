//
//  MedicineFilterViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 14/03/2022.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay

enum medicineFilter {
    case OtherCategories
    case MedicineCategories
    case BrandsCategories

}

class MedicineFilterViewController: BaseViewController {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var sreachtextField: UITextField!
    @IBOutlet weak var bacndsCatigryCollectionView: UICollectionView!
    @IBOutlet weak var filterSegment: UISegmentedControl!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var medicineFilterCollectionView: UICollectionView!
    private var searchName = String()
    var articleDetailsViewModel = MedicineFilterViewModel()
    private var router = MedicineFilterRouter()
    private var filterSelected: medicineFilter = .OtherCategories
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        bindBranchToCollectionView()
        articleDetailsViewModel.getFilters(MedicineCategoryFor:2, MedicineCategoryName: searchName)
        sementControllTapped()
        bindtoLoader()
        bindBrandsToCollectionView()
        searchButtonTapped()
        selectFilter()
    }
    
    func searchButtonTapped() {
        searchButton.rx.tap.subscribe { [weak self] _ in
            guard self?.sreachtextField.text != "" else {
                Alert().displayError(text: "Please enter your search", viewController: self!)

                return
            }
            if self?.filterSelected == .OtherCategories  {
                self?.articleDetailsViewModel.getFilters(MedicineCategoryFor: 2, MedicineCategoryName: self?.sreachtextField.text ?? "")
                self?.medicineFilterCollectionView.reloadData()

            }
            else if self?.filterSelected == .MedicineCategories {
                self?.articleDetailsViewModel.getFilters(MedicineCategoryFor: 1, MedicineCategoryName: self?.sreachtextField.text ?? "")
                self?.medicineFilterCollectionView.reloadData()

            }
            else {
                self?.articleDetailsViewModel.getFiltersForBrands(MedicineCategoryName: self?.sreachtextField.text ?? "")
                self?.bacndsCatigryCollectionView.reloadData()
            }
            self?.sreachtextField.text = ""
        }.disposed(by: self.disposeBag)

        
    }
    
    func selectFilter() {
        Observable.zip(bacndsCatigryCollectionView
                        .rx
                        .itemSelected,bacndsCatigryCollectionView.rx.modelSelected(FilterBrandMessage.self)).bind { [weak self] selectedIndex, product in
            
            LocalStorage().saveBrandFilter(using: product.id ?? 0)
            self?.router.backAction()
        }.disposed(by: self.disposeBag)
    }
    
    func showOtherCatoreyCollectionView(){
        DispatchQueue.main.async {
            self.medicineFilterCollectionView.isHidden = false
            self.bacndsCatigryCollectionView.isHidden = true
        }
       
    }
    
    func showBrandsCollecitonView() {
        DispatchQueue.main.async {
        self.medicineFilterCollectionView.isHidden = true
        self.bacndsCatigryCollectionView.isHidden = false
       }
    }
    func bindBranchToCollectionView() {
        articleDetailsViewModel.medicineFilters
            .bind(to: self.medicineFilterCollectionView
                    .rx
                    .items(cellIdentifier: String(describing:  FilterCatogryCollectionViewCell.self),
                           cellType: FilterCatogryCollectionViewCell.self)) { row, model, cell in
                cell.filterCatogryLabel.text = model.categoryName
                
            }.disposed(by: self.disposeBag)
    }
 
    func bindBrandsToCollectionView() {
        articleDetailsViewModel.medicineFiltersForBrands
            .bind(to: self.bacndsCatigryCollectionView
                    .rx
                    .items(cellIdentifier: String(describing:  BrandsCatogryCollectionViewCell.self),
                           cellType: BrandsCatogryCollectionViewCell.self)) { row, model, cell in
                cell.setDataForBrands(braand: model)
            }.disposed(by: self.disposeBag)
    }
    
    func bindtoLoader(){
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
    func sementControllTapped() {
        filterSegment.rx.selectedSegmentIndex.subscribe { [weak self] index in
            if index.element == 0 {
                self?.filterSelected = .OtherCategories
                self?.articleDetailsViewModel.getFilters(MedicineCategoryFor: 2, MedicineCategoryName: self?.searchName ?? "")
            }
            else if index.element == 1 {
                self?.filterSelected = .MedicineCategories
                self?.articleDetailsViewModel.getFilters(MedicineCategoryFor: 1, MedicineCategoryName: self?.searchName ?? "")

            }
            else {
                self?.filterSelected = .BrandsCategories
                self?.articleDetailsViewModel.getFiltersForBrands(MedicineCategoryName: self?.searchName ?? "")
            }
           
            self?.medicineFilterCollectionView.reloadData()
            
        }.disposed(by: self.disposeBag)
    }
}

extension MedicineFilterViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
