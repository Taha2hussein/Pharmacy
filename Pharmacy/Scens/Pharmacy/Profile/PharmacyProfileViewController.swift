//
//  PharmacyProfileViewController.swift
//  Pharmacy
//
//  Created by A on 08/02/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

enum segmet {
    case brahnch
    case pharmacist
}

class PharmacyProfileViewController: BaseViewController {
    
    @IBOutlet weak var uperView: UIView!
    @IBOutlet weak var addBewPharmacyButton: UIButton!
    @IBOutlet weak var branchTableview: UITableView!
    @IBOutlet weak var segmentPhramcy: UISegmentedControl!
    @IBOutlet weak var seeAllReviewsButton: UIButton!
    @IBOutlet weak var reviewsNo: UILabel!
    @IBOutlet weak var editPharmacyButton: UIButton!
    @IBOutlet weak var pharmacyBrnachNo: UILabel!
    @IBOutlet weak var pharmacyName: UILabel!
    @IBOutlet weak var pharmacyImage: UIImageView!
    
    var articleDetailsViewModel = PharmacyProfileViewModel()
    private var router = PharmacyProfileRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        embedUperView()
        setup()
        segmentAction()
        bindViewControllerRouter()
        subscribeToLoader()
        bindBranchToTableView()
        assignParmacyProfile()
        subsribeToSegmentSelected()
    }
    
    func setup(){
        self.branchTableview.rowHeight = 120
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
    
    func bindPharmacistToTableView() {
        articleDetailsViewModel.brahcnhPharmacist
            .bind(to: self.branchTableview
                    .rx
                    .items(cellIdentifier: String(describing:  PharmacyProfileTableViewCell.self),
                           cellType: PharmacyProfileTableViewCell.self)) { row, model, cell in
                cell.pharmcistView.isHidden = false
                cell.branchView.isHidden = true
                cell.setDataForPharmacist(pharmacist: model)
                
            }.disposed(by: self.disposeBag)
    }
    
    func bindBranchToTableView() {
        articleDetailsViewModel.brnachesProfile
            .bind(to: self.branchTableview
                    .rx
                    .items(cellIdentifier: String(describing:  PharmacyProfileTableViewCell.self),
                           cellType: PharmacyProfileTableViewCell.self)) { row, model, cell in
                cell.pharmcistView.isHidden = true
                cell.branchView.isHidden = false
                cell.setData( product:model)
                
            }.disposed(by: self.disposeBag)
    }
    
    func segmentAction() {
        segmentPhramcy.rx.selectedSegmentIndex.subscribe { [weak self] index in
            if index.element == 0 {
                self?.articleDetailsViewModel.segmentSelected.accept(.brahnch)
            }  else {
                self?.articleDetailsViewModel.segmentSelected.accept(.pharmacist)
            }
            
            self?.branchTableview.reloadData()
            
        }.disposed(by: self.disposeBag)
    }
    
    func subsribeToSegmentSelected() {
        articleDetailsViewModel.segmentSelected.subscribe {[weak self] segment in
            self?.branchTableview.dataSource = nil
            self?.branchTableview.delegate = nil
            self?.articleDetailsViewModel.getPharmacyProfile()
            
            if segment.element == .brahnch {
                self?.bindBranchToTableView()
            }
            else {
                self?.bindPharmacistToTableView()
            }
            
        }.disposed(by: self.disposeBag)
        
    }
    
    func embedUperView() {
        let vc = UperRouter().viewController
        self.embed(vc, inParent: self, inView: uperView)
    }
    
}

extension PharmacyProfileViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}

extension PharmacyProfileViewController {
    func assignParmacyProfile() {
        articleDetailsViewModel.pharmacyObject.subscribe {[weak self] pharmacy in
            DispatchQueue.main.async {
                if let pahrmacy = pharmacy.element {
                    self?.pharmacyBrnachNo.text = "\(pahrmacy.message.branchesCount)" + " Branch "
                    self?.pharmacyName.text = pahrmacy.message.pharmacyName
                    self?.reviewsNo.text = "\(Int(pahrmacy.message.reviews))"
                    self?.setImage(image: pahrmacy.message.image)
                }
            }
        } .disposed(by: self.disposeBag)
        
    }
    
    func setImage(image: String) {
        if let url = URL(string: baseURLImage + (image)) {
            self.pharmacyImage.load(url: url)
        }
    }
}
