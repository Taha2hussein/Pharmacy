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
import SDWebImage

var selectBrnachObserver = PublishSubject<Bool>()
class AddPharmacistViewController: BaseViewController {
    
    @IBOutlet weak var pharmacistLabel: UILabel!
    @IBOutlet weak var ownerSuperAdminLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var pharmacistImage: UIImageView!
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
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var flagImage: UIImageView!

    var articleDetailsViewModel = AddPharmacistViewModel()
    private var router = AddPharmacistRouter()
    private var DatePickers = DatePicker()
    //    private var dailyOrdersBranches = [TotalDailyOrdersBranch]()
    //    private var allBranchesList = [AllBranchesBranch]()
    let genderDropDown = ["Male","Female"]
    let selectCityFromDropDown = DropDown()
    let radioController: RadioButtonController = RadioButtonController()
    private var selectedBranch = [Int]()
    private var genderSelected =  1
    private var profileImagePath = ""
    private var type : Int = 2
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
        subsribeEditPharmcist()
        //        validateData()
        backButtonTapped()
        setGesturesForBirthDate()
        saveTapped()
        subscribeToLoader()
        requestBranchesList()
        //        subscribeToBranches()
        setGesturesForBranches()
        bindImageToOwnerImage()
        subscribeToLoaderForImage()
        selectImageTappedForOwner()
        addImageToTextFields()
        observeSelectedBranch()
        setUpPhone()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectBrnachObserver.onNext(false)
        if articleDetailsViewModel.addOrEdit == true {
            articleDetailsViewModel.getPharmacistForEdit()
        }
        headerLabel.text = articleDetailsViewModel.headerLabel.localized
        
    }
    
    func setUpPhone() {
        ImageCountryCode().setCountryCode(countryImage: flagImage)
        
    }
    
    
    func addImageToTextFields() {
        gender.setRightImage(imageName: "icNext",textField: gender)
        allBranches.setRightImage(imageName: "icNext",textField: allBranches)
    }
    
    func observeSelectedBranch() {
        selectBrnachObserver.subscribe { [weak self] selectedBranch in
            if selectedBranch.element == true {
                var selectedBranches = String()
                let selectedElements = singlton.shared.selectedBrnachForAddPharmacistName
                for (index,item) in selectedElements.enumerated() {
                    selectedBranches += item
                    if index != selectedElements.count - 1 {
                        selectedBranches += ","
                    }
                }
                self?.allBranches.text = selectedBranches
            }
        }.disposed(by: self.disposeBag)

    }
    
    func validateData() {
        articleDetailsViewModel.isValid.subscribe(onNext: {[weak self] (isEnabled) in
            isEnabled ? (self?.saveButton.isEnabled = true) : (self?.saveButton.isEnabled = false)
        }).disposed(by: self.disposeBag)
        
    }
    func requestBranchesList() {
        articleDetailsViewModel.getPharmacyBranches()
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
        pharmacistLabel.textColor = .blue
    }
    
    func PharmacistAction() {
        pharmacistButton.rx.tap.subscribe {[weak self] _ in
            self?.radioController.buttonArrayUpdated(buttonSelected: (self?.pharmacistButton)!)
            self?.pharmacistLabel.textColor = .blue
            self?.ownerSuperAdminLabel.textColor = .gray
            self?.type = 2
        }.disposed(by: self.disposeBag)
        
    }
    
    func subscribeToLoaderForImage() {
        AlamofireMultiPart.shared.state.isLoading.subscribe(onNext: {[weak self] (isLoading) in
            DispatchQueue.main.async {
                if isLoading {
                    self?.showLoading()
                    
                } else {
                    self?.hideLoading()
                }
            }
        }).disposed(by: self.disposeBag)
    }
    
    func useWPmediaPicker() {
        
        ImagePickerManager().pickImage(self){ image in
            self.articleDetailsViewModel.selectedImageOwner.onNext(image)
        }
    }
    
    func selectImageTappedForOwner() {
        
        changeImage.rx.tap.subscribe { [weak self] _ in
            self?.useWPmediaPicker()
        }.disposed(by: self.disposeBag)
        
    }
    
    func bindImageToOwnerImage() {
        articleDetailsViewModel.selectedImageOwner.subscribe {[weak self] image in
            if let image = image.element {
                DispatchQueue.main.async {
                    self?.pharmacistImage.image = image
                    let comperesImage = UploadDataa(data: image.jpegData(compressionQuality: 0.1)!, Key: "personal_image")
                    AlamofireMultiPart.shared.PostMultiWithModel(model: SuccessModelImage.self, url: uploadImageApi, Images: [comperesImage], header: headers, parameters: [:],completion: self!.ProfileImageNetwork)
                }
            }
        }.disposed(by: self.disposeBag)
        
    }
    
    func bindBranches(branches:[EditPharmacistBranch]) {
        var selectedBranches = String()
        let selectedElements = branches
        for (index,item) in selectedElements.enumerated() {
            selectedBranches += item.branchName ?? ""
            singlton.shared.selectedBrnachForAddPharmacist.append(item.branchID ?? 0)
            singlton.shared.selectedBrnachForAddPharmacistName.append(item.branchName ?? "")
            if index != selectedElements.count - 1 {
                selectedBranches += ","
            }
            
        }
        self.allBranches.text = selectedBranches
    }
    
    func setDateToRole(type:Int) {
        if type == 1 {
            self.ownerSuperAdminLabel.textColor = .blue
            self.pharmacistLabel.textColor = .gray
            self.type = 1
            self.radioController.buttonArrayUpdated(buttonSelected: (self.ownerSuperAdminButton)!)

        }
        else {
            self.type = 2
            self.ownerSuperAdminLabel.textColor = .gray
            self.pharmacistLabel.textColor = .blue
            self.radioController.buttonArrayUpdated(buttonSelected: (self.pharmacistButton)!)

        }
    }
    
    func subsribeEditPharmcist() {
        articleDetailsViewModel.EditPharmacistInstance.subscribe { [weak self] editPharmacist in
            if let editPharmcist = editPharmacist.element {
                DispatchQueue.main.async {
                    self?.firstNameAr.text = editPharmcist.firstNameAr
                    self?.firstNameEn.text = editPharmcist.firstNameEn
                    self?.lastNameAr.text = editPharmcist.lastNameEAr
                    self?.lastNameEn.text = editPharmcist.lastNameEn
                    self?.emailField.text = editPharmcist.email
                    self?.mobileField.text = editPharmcist.mobileNumber
                    self?.profileImagePath = editPharmcist.image ?? ""
                    self?.bindBranches(branches: editPharmcist.branches ?? [])
                    self?.setDateToRole(type: editPharmcist.type ?? 1)
                    if let url = URL(string: baseURLImage + (editPharmcist.image ?? "")) {
                        self?.pharmacistImage.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar"))
           
                    }
                    if editPharmcist.gender == 2 {
                        self?.gender.text = "Male".localized
                    }
                    else {
                        self?.gender.text  = "Female".localized
                    }
                    
                    if let convertedDate = convertDateFormat(inputDate: editPharmcist.dateOfBirth ?? "")as? String {
                        self?.date_birth.text = convertedDate
                    }
                }
            }
            
            // bind date
            self?.bindFirstNameEN()
            self?.bindLastNameEN()
            self?.bindFirstNameAR()
            self?.bindLastNameAR()
            self?.bindEmail()
            self?.bindMobile()
            self?.bindGender()
            self?.bindDate_Birth()
        }.disposed(by: self.disposeBag)
        
    }
    
    func setGesturesForBranches() {
        let branches = UITapGestureRecognizer(target: self, action: #selector(self.tapBranches))
        self.allBranches.isUserInteractionEnabled = true
        self.allBranches.addGestureRecognizer(branches)
    }
    
    func setGesturesForBirthDate() {
        let birthDate = UITapGestureRecognizer(target: self, action: #selector(self.tapBirthDate))
        self.date_birth.isUserInteractionEnabled = true
        self.date_birth.addGestureRecognizer(birthDate)
    }
    
    func ownerSuperAdminAction() {
        ownerSuperAdminButton.rx.tap.subscribe {[weak self] _ in
            self?.radioController.buttonArrayUpdated(buttonSelected: (self?.ownerSuperAdminButton)!)
            self?.type = 1
            self?.pharmacistLabel.textColor = .gray
            self?.ownerSuperAdminLabel.textColor = .blue
        }.disposed(by: self.disposeBag)
    }
    
    func setGesturesForGender() {
        let gender = UITapGestureRecognizer(target: self, action: #selector(self.tapGender))
        self.gender.isUserInteractionEnabled = true
        self.gender.addGestureRecognizer(gender)
    }
    
    
    func showAlert(message:String) {
        Alert().displayError(text: message, viewController: self)
    }
    
    func validateALLField() {
        if firstNameEn.text!.isEmpty || firstNameAr.text!.isEmpty || lastNameAr.text!.isEmpty || lastNameEn.text!.isEmpty || mobileField.text!.isEmpty || gender.text!.isEmpty  {
            showAlert(message: LocalizedStrings().emptyField)
        }
        
        else if isEmailValid(emailField.text!) == false {
            showAlert(message: LocalizedStrings().unvalidemail)
        }
        
//        else if profileImagePath == "" {
//            showAlert(message: LocalizedStrings().uploadImage)
//        }
        
        else if singlton.shared.selectedBrnachForAddPharmacist.count == 0 {
            showAlert(message: LocalizedStrings().selectBranch)
        }
        
        else if mobileField.text!.count < 11 {
            showAlert(message: LocalizedStrings().validPhoneNumber)
        }
        
        else {
            sendDataToSave()
        }
        
    }
    
    func sendDataToSave() {
        (self.gender.text == "Male") ? (self.genderSelected = 1) : (self.genderSelected = 2)
        self.articleDetailsViewModel.addPharmacistAction(gender: self.genderSelected , branches: singlton.shared.selectedBrnachForAddPharmacist,role:self.type , image: self.profileImagePath, dateBirth: self.date_birth.text ?? "")
    }
    
    func saveTapped() {
        saveButton.rx.tap.subscribe { [weak self] _ in
            self?.validateALLField()
        } .disposed(by: self.disposeBag)
        
    }
    
    func backButtonTapped(){
        backButton.rx.tap.subscribe { [weak self] _   in
            self?.router.backView()
            singlton.shared.selectedBrnachForAddPharmacistName.removeAll()
            singlton.shared.selectedBrnachForAddPharmacist.removeAll()
            selectBrnachObserver.onNext(false)
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
        let subView = UIStoryboard.init(name: Storyboards.AddPharmacy.rawValue, bundle: nil).instantiateViewController(withIdentifier: ViewController.BrnachPopViewViewController.rawValue)as! BrnachPopViewViewController
        
        subView.view.frame = (self.view.bounds)
        self.view.addSubview(subView.view)
    }
    
    @objc
    func tapBirthDate(sender:UITapGestureRecognizer) {
        self.DatePickers.ShowPickerView(pickerView: self, completionHandler: { date in
            //            self.endDate = date
            self.date_birth.text = date
        })
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

extension AddPharmacistViewController {
    func ProfileImageNetwork(result : ServerResponse<SuccessModelImage>){
        switch result {
        case .success(let model):
            if model.successtate == 200 {
                self.profileImagePath = model.message ?? ""
                print(model.message ?? "","model.messages")
            }else{
                print("model: \(model)")
                //            self.showMessage(title: "", sub: model.errormessage, type: .error, layout: .messageView)
            }
            break
        case .failure(let err):
            guard let err = err else {return}
            print("err: \(err)")
        }
    }
    
}
