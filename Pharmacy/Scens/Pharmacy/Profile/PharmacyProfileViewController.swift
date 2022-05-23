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
    @IBOutlet weak var headerView: UIView!
    
    var articleDetailsViewModel = PharmacyProfileViewModel()
    private var router = PharmacyProfileRouter()
    private var review = [ReviewsDetail]()
    private var segmentSelected: segmet = .brahnch
    override func viewDidLoad() {
        super.viewDidLoad()
        embedUperView()
        setup()
        segmentAction()
        bindViewControllerRouter()
        subscribeToLoader()
        bindBranchToTableView()
        assignParmacyProfile()
        editPharmacyAction()
        seeAllReview()
        addPharmacyAction()
        articleDetailsViewModel.embedUperView(uperView: headerView)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    func seeAllReview() {
        seeAllReviewsButton.rx.tap.subscribe { [weak self] _ in
            self?.articleDetailsViewModel.seAllReviews(review:  self?.review ?? [])
        } .disposed(by: self.disposeBag)

    }
    
    func addPharmacyAction() {
        addBewPharmacyButton.rx.tap.subscribe { [weak self] _ in
            if self?.segmentSelected == .brahnch {
            self?.articleDetailsViewModel.pushNextView()
            }
            else {
                self?.router.addPharmacist()
            }
        } .disposed(by: self.disposeBag)

    }
    
    func editPharmacyAction() {
//        editPharmacyButton.rx.tap.subscribe { [weak self]  _ in
//            self?.articleDetailsViewModel.pushNextView()
//        } .disposed(by: self.disposeBag)
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
    
                cell.pharmacistActivationButton.rx.tap.subscribe { [weak self] _ in
                    guard let id = model.id else {return}
                    self?.articleDetailsViewModel.activePharmacist(id: id, activation: true)
                } .disposed(by: cell.bag)

                
                // branch menu button
                cell.pharmacistMenu.rx.tap.subscribe {  _ in
                    cell.pharmcistView.isHidden = true
                    cell.branchView.isHidden = true
                    cell.pharmacistMenuView.isHidden = false
                } .disposed(by: cell.bag)

                // Deactivate
                cell.pharmacistMenuCDeactivate.rx.tap.subscribe { [weak self] _ in
                    guard let id = model.id else {return}
                    self?.articleDetailsViewModel.activePharmacist(id: id, activation: false)
                    cell.pharmacistMenuView.isHidden = true

                }.disposed(by: cell.bag)
                
                // edit Branch
                cell.pharmacistMenuEdit.rx.tap.subscribe { [weak self] _ in
                    cell.pharmacistMenuView.isHidden = true
                    self?.router.addPharmacist()
                }.disposed(by: cell.bag)

                // close menu
                cell.pharmacistMenuClose.rx.tap.subscribe { _ in
                    cell.pharmacistMenuView.isHidden = true
                    cell.pharmcistView.isHidden = false

                }.disposed(by: cell.bag)
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
                
                cell.branchActiveButton.rx.tap.subscribe { [weak self] _ in
                    guard let branchId = model.id else {return}
                    self?.articleDetailsViewModel.activeBranch(branchId: branchId, activation: true)
                } .disposed(by: cell.bag)

                // branch menu button
                cell.branhcMenu.rx.tap.subscribe {  _ in
                    cell.pharmcistView.isHidden = true
                    cell.branchView.isHidden = true
                    cell.branchMenuView.isHidden = false
                } .disposed(by: cell.bag)

                // Deactivate
                cell.branchMenuDeleteButton.rx.tap.subscribe { [weak self] _ in
                    guard let branchId = model.id else {return}
                    self?.articleDetailsViewModel.activeBranch(branchId: branchId, activation: false)
                    cell.branchMenuView.isHidden = true

                }.disposed(by: cell.bag)
                
                // edit Branch
                cell.branchMenuEditButton.rx.tap.subscribe { [weak self] _ in
                    cell.branchMenuView.isHidden = true
                    self?.articleDetailsViewModel.pushNextView()
                }.disposed(by: cell.bag)

                // close menu
                cell.branchMenuCloseButton.rx.tap.subscribe { _ in
                    cell.branchMenuView.isHidden = true
                    cell.branchView.isHidden = false

                }.disposed(by: cell.bag)
                
            }.disposed(by: self.disposeBag)
    }
    
    func segmentAction() {
        segmentPhramcy.rx.selectedSegmentIndex.subscribe { [weak self] index in
            if index.element == 0 {
                self?.segmentSelected = .brahnch
                self?.articleDetailsViewModel.segmentSelected.accept(.brahnch)
            }  else {
                self?.segmentSelected = .pharmacist
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
                    self?.pharmacyBrnachNo.text = "\(pahrmacy.message?.branchesCount ?? 0)" + " Branch "
                    self?.pharmacyName.text = pahrmacy.message?.pharmacyName
                    self?.reviewsNo.text = "\(Int(pahrmacy.message?.reviews ?? 0.0))"
                    self?.setImage(image: pahrmacy.message?.image ?? "")
                    self?.review = pahrmacy.message?.reviewsDetails ?? []
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
