//
//  EditProfileViewController.swift
//  Pharmacy
//
//  Created by A on 31/01/2022.
//


import UIKit
import RxSwift
import RxCocoa
import RxRelay
import DropDown

class EditProfileViewController: BaseViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var firstNameAR: UITextField!
    @IBOutlet weak var savebutton: UIButton!
    @IBOutlet weak var role: UILabel!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var daet_Birth: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var lastNameAR: UITextField!
    @IBOutlet weak var lastNameEN: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var changeProfileButton: UIButton!
    @IBOutlet weak var ownerImage: UIButton!
    
    var articleDetailsViewModel = EditProfileViewModel()
    private var router = EditProfileRouter()
    private var genderId = Int()
    let selectCityFromDropDown = DropDown()

    lazy var dropDowns: DropDown = {
        return self.selectCityFromDropDown
    }()
    
   let genderDropDown = ["Male","Female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        setup()
        bindFirstNameEN()
        bindLastNameEN()
        bindFirstNameAR()
        bindLastNameAR()
        bindEmail()
        bindMobile()
        bindGender()
        bindDate_Birth()
        backView()
        setGesturesForGender()
        subscribeToLoader()
//        validateData()
        saveAction()
    }
    
    func setup() {
        articleDetailsViewModel.setup()
    }
    
    func setGesturesForGender() {
        let gender = UITapGestureRecognizer(target: self, action: #selector(self.tapGender))
        self.gender.isUserInteractionEnabled = true
        self.gender.addGestureRecognizer(gender)
    }
    
    func validateData() {
        articleDetailsViewModel.isValid.subscribe(onNext: {[weak self] (isEnabled) in
            isEnabled ? (self?.savebutton.isEnabled = true) : (self?.savebutton.isEnabled = false)
        }).disposed(by: self.disposeBag)

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
    
    func saveAction() {
        savebutton.rx.tap.subscribe { [weak self] _ in
            (self?.gender.text == "Male") ? (self?.genderId = 1) : (self?.genderId = 2)
            self?.articleDetailsViewModel.editProfile(gender: self?.genderId ?? 1)
        }.disposed(by: self.disposeBag)

    }
    
    func backView() {
        backButton.rx.tap.subscribe { [weak self] _ in
            self?.articleDetailsViewModel.backNavigationview()
        }.disposed(by: self.disposeBag)

    }
}

extension EditProfileViewController {
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
}

extension EditProfileViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}

extension EditProfileViewController {
    
    func bindFirstNameEN() {
        firstName.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.firstNameEN).disposed(by: self.disposeBag)
    }
    
    func bindLastNameEN() {
        lastNameEN.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.lastNameEN).disposed(by: self.disposeBag)
    }
    
    func bindFirstNameAR() {
        firstNameAR.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.firstNameAR).disposed(by: self.disposeBag)
    }
    
    func bindLastNameAR() {
        lastNameAR.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.lastNameAR).disposed(by: self.disposeBag)
    }
    
    func bindEmail() {
        email.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.email).disposed(by: self.disposeBag)
    }
    
    func bindMobile() {
        mobile.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.phone).disposed(by: self.disposeBag)
    }
    
    func bindGender() {
        gender.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.gender).disposed(by: self.disposeBag)
    }
    
    func bindDate_Birth() {
        daet_Birth.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.date_Birth).disposed(by: self.disposeBag)
    }
}
