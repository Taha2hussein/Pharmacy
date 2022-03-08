//
//  AddPharmacistViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 05/03/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import DropDown
class AddPharmacistViewController: BaseViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var pharmacistImage: UIButton!
    @IBOutlet weak var changeImage: UIButton!
    @IBOutlet weak var firstNameAr: UITextField!
    @IBOutlet weak var firstNameEn: UITextField!
    @IBOutlet weak var lastNameAr: UITextField!
    @IBOutlet weak var lastNameEn: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var date_birth: UITextField!
    @IBOutlet weak var pharmacistButton: UIButton!
    @IBOutlet weak var ownerSuperAdminButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var allBranches: UITextField!
    
    var articleDetailsViewModel = AddPharmacistViewModel()
    private var router = AddPharmacistRouter()
    
//    private var dailyOrdersBranches = [TotalDailyOrdersBranch]()
    private var allBranchesList = [AllBranchesBranch]()
    let genderDropDown = ["Male","Female"]
    let selectCityFromDropDown = DropDown()
    let radioController: RadioButtonController = RadioButtonController()
    private var selectedBranch = [Int]()
    private var genderSelected =  1
    private var type: Int  = 1
    lazy var dropDowns: DropDown = {
        return self.selectCityFromDropDown
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindFirstNameEN()
        bindLastNameEN()
        bindFirstNameAR()
        bindLastNameAR()
        bindEmail()
        bindMobile()
        bindGender()
        bindDate_Birth()
        bindViewControllerRouter()
        setGesturesForGender()
        setUPForDelivery()
        PharmacistAction()
        ownerSuperAdminAction()
        validateData()
        backButtonTapped()
        saveTapped()
        subscribeToLoader()
        requestBranchesList()
        subscribeToBranches()
        setGesturesForBranches()
    }
    
    func validateData() {
        articleDetailsViewModel.isValid.subscribe(onNext: {[weak self] (isEnabled) in
            isEnabled ? (self?.saveButton.isEnabled = true) : (self?.saveButton.isEnabled = false)
        }).disposed(by: self.disposeBag)

    }
    func requestBranchesList() {
        articleDetailsViewModel.getPharmacyBranches()
    }
    
    func subscribeToBranches() {
        articleDetailsViewModel.AllBranchesInstance.subscribe {[weak self] branches in
            self?.allBranchesList = branches.element!
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
    
    func setUPForDelivery() {
        radioController.buttonsArray = [pharmacistButton,ownerSuperAdminButton]
        radioController.defaultButton = pharmacistButton

    }
    
    func PharmacistAction() {
        pharmacistButton.rx.tap.subscribe {[weak self] _ in
            self?.radioController.buttonArrayUpdated(buttonSelected: (self?.pharmacistButton)!)
            self?.type = 1
        }.disposed(by: self.disposeBag)
        
    }
    
    func setGesturesForBranches() {
        let branches = UITapGestureRecognizer(target: self, action: #selector(self.tapBranches))
        self.allBranches.isUserInteractionEnabled = true
        self.allBranches.addGestureRecognizer(branches)
        
      
    }
    
    func ownerSuperAdminAction() {
        ownerSuperAdminButton.rx.tap.subscribe {[weak self] _ in
            self?.radioController.buttonArrayUpdated(buttonSelected: (self?.ownerSuperAdminButton)!)
            self?.type = 2
        }.disposed(by: self.disposeBag)
    }
    
    func setGesturesForGender() {
        let gender = UITapGestureRecognizer(target: self, action: #selector(self.tapGender))
        self.gender.isUserInteractionEnabled = true
        self.gender.addGestureRecognizer(gender)
    }
    
    func saveTapped() {
        saveButton.rx.tap.subscribe { [weak self] _ in
            (self?.gender.text == "Male") ? (self?.genderSelected = 1) : (self?.genderSelected = 2)
            self?.articleDetailsViewModel.addPharmacistAction(gender: self?.genderSelected ?? 1 , branches: self?.selectedBranch ?? [],role:self!.type , image: "test")
        } .disposed(by: self.disposeBag)

    }
    
    func backButtonTapped(){
        backButton.rx.tap.subscribe { [weak self] _   in
            self?.router.backView()
        }.disposed(by: self.disposeBag)

    }
}

extension AddPharmacistViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
extension AddPharmacistViewController {
    @objc
    func tapGender(sender:UITapGestureRecognizer) {
        
        selectCityFromDropDown.anchorView = gender
        selectCityFromDropDown.direction = .any
        selectCityFromDropDown.backgroundColor = UIColor.white
        selectCityFromDropDown.bottomOffset = CGPoint(x: 0, y:(selectCityFromDropDown.anchorView?.plainView.bounds.height)!)

        self.selectCityFromDropDown.dataSource = genderDropDown
        selectCityFromDropDown.show()
        // Action triggered on selection
        
        selectCityFromDropDown.selectionAction = { [weak self] (index, item) in
            self?.gender.text = item
            
        }
        
    }
    
    @objc
    func tapBranches(sender:UITapGestureRecognizer) {
        
        selectCityFromDropDown.anchorView = allBranches
        selectCityFromDropDown.direction = .any
        selectCityFromDropDown.backgroundColor = UIColor.white
        selectCityFromDropDown.bottomOffset = CGPoint(x: 0, y:(selectCityFromDropDown.anchorView?.plainView.bounds.height)!)
        let branches = allBranchesList.map({($0.branchName ?? "") })
        self.selectCityFromDropDown.dataSource = branches
        selectCityFromDropDown.show()
        // Action triggered on selection
        
        selectCityFromDropDown.selectionAction = { [weak self] (index, item) in
            self?.selectedBranch.append(self?.allBranchesList[index].branchID ?? 0)
            self?.allBranches.text = item
        }
            
        }
}

extension AddPharmacistViewController {
    
    func bindFirstNameEN() {
        firstNameEn.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.firstNameEN).disposed(by: self.disposeBag)
    }
    
    func bindLastNameEN() {
        lastNameEn.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.lastNameEN).disposed(by: self.disposeBag)
    }
    
    func bindFirstNameAR() {
        firstNameAr.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.firstNameAR).disposed(by: self.disposeBag)
    }
    
    func bindLastNameAR() {
        lastNameAr.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.lastNameAR).disposed(by: self.disposeBag)
    }
    
    func bindEmail() {
        emailField.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.email).disposed(by: self.disposeBag)
    }
    
    func bindMobile() {
        mobileField.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.phone).disposed(by: self.disposeBag)
    }
    
    func bindGender() {
        gender.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.gender).disposed(by: self.disposeBag)
    }
    
    func bindDate_Birth() {
        date_birth.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.date_Birth).disposed(by: self.disposeBag)
    }
}
