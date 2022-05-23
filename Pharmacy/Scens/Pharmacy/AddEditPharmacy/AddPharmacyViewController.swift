//
//  AddPharmacyViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 03/03/2022.
//

import UIKit
import RxCocoa
import RxRelay
import RxSwift
import DropDown
import SwiftUI

enum deliveryTime {
    case firstTime
    case secondTime
    case thirdTime
}
class AddPharmacyViewController: BaseViewController {
    
    @IBOutlet weak var deliveryTimeStackView: UIStackView!
    @IBOutlet weak var howFarTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var fromTimeLabel: UILabel!
    @IBOutlet weak var openingFullTimeLabel: UILabel!
    @IBOutlet weak var pharmacyDeliveryNoLabel: UILabel!
    @IBOutlet weak var pharmacyDeliveryYesLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var backButtonAction: UIButton!
    @IBOutlet weak var markLocationButton: UIButton!
    @IBOutlet weak var kilometerField: UITextField!
    @IBOutlet weak var openingCustomTime: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    @IBOutlet weak var fromDateButton: UIButton!
    @IBOutlet weak var chooseDateStackView: UIStackView!
    @IBOutlet weak var openingfullTime: UIButton!
    
    @IBOutlet weak var enterFeesTime: UILabel!
    @IBOutlet weak var enterFeesHeaderLabel: UILabel!
    @IBOutlet weak var enterFeesStackView: UIStackView!
    @IBOutlet weak var enterFeesField: UITextField!
    //    @IBOutlet weak var deliveryFessNo: UIButton!
//    @IBOutlet weak var deliveryFeesYes: UIButton!
    
    
    @IBOutlet weak var firstDeliveryTimeButton: UIButton!
    @IBOutlet weak var firstDeliveryTimeLabel: UILabel!
    @IBOutlet weak var secondDeliveryTimeButton: UIButton!
    @IBOutlet weak var secondDeliveryTimeLabel: UILabel!
    @IBOutlet weak var thirdDeliveryTimeButton: UIButton!
    @IBOutlet weak var thirdDeliveryTimeLabel: UILabel!
    @IBOutlet weak var enterDeliveryTimeTextField: UITextField!
    
    @IBOutlet weak var paymentOnline: UIButton!
    @IBOutlet weak var paymentCashButton: UIButton!
    @IBOutlet weak var pharmacyDeliveryNo: UIButton!
    @IBOutlet weak var pharmacyDeliveryYes: UIButton!
    @IBOutlet weak var landmarkAr: UITextField!
    @IBOutlet weak var landmarkEn: UITextField!
//    @IBOutlet weak var buildingNameAr: UITextField!
//    @IBOutlet weak var buildingNameEn: UITextField!
//    @IBOutlet weak var streetNameAr: UITextField!
//    @IBOutlet weak var streetNameEn: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var areaField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var branchNameAr: UITextField!
    @IBOutlet weak var brnachNameEn: UITextField!
    @IBOutlet weak var saveAction: UIButton!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var headerLabel: UILabel!
    
    var articleDetailsViewModel = AddPharmacyViewModel()
    private var router = AddPharmacyRouter()
    private var DatePickers = DatePicker()
    private var hasDelivery = false
    private var deliveryFees = false
    private var openingTime = false
    private var paymentWay: Int = 1
    private var countrySelectedIndex = 0
    private var citySelectedIndex = 0
    private var countrySelected = 1
    private var citySelected = 0
    var deliveryTimes: Int = 0
    private var areaSelected = 0
    private var deliveryTime : deliveryTime = .firstTime
    let radioController: RadioButtonController = RadioButtonController()
    let radioControlleDeliveryFees: RadioButtonController = RadioButtonController()
    let radioControllerPayment: RadioButtonController = RadioButtonController()
    let radioControllerOpeningtime: RadioButtonController = RadioButtonController()
    private var countryList = [CountryMessage]()
    lazy var dropDowns: DropDown = {
        return self.selectCityFromDropDown
    }()
    let selectCityFromDropDown = DropDown()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        //        validateData()
        setUPForPayment()
        setUPForDelivery()
        setUPForDeliveryServiceFeess()
        bindAllTextFields()
//        bindbrnachNameEn()
//        bindbranchNameAr()
//        bindmobile()
//        bindcityField()
//        bindareaField()
//        bindstreetNameEn()
//        bindstreetNameAr()
//        bindbuildingNameEn()
//        bindbuildingNameAr()
//        bindlandmarkEn()
//        bindlandmarkAr()
//        bindhowFarService()
        showFromDateAction()
        subscribeToLoader()
        NoActionForDelivery()
        yesActionForDelivery()
        firstActionForDeloveryFees()
        secondActionForDeloveryFees()
        thirdDeliveryTimeAction()
        PaymentCash()
        PaymentOnline()
        requestCountryList()
        subscribeToCountry()
        showMapView()
        setGesturesForCountry()
        setGesturesForCity()
        setGesturesForArea()
        setUPForOpeingTime()
        ActionForOpeningFullTime()
        ActionForOpeningCustomtime()
        showEndDateAction()
        saveTapped()
        backTapped()
        subsribeEditBranch()
        addImageToTextFields()
        setUPForDeliveryServiceFeess()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLocationName()
        
        if articleDetailsViewModel.addOrEdit == true {
            articleDetailsViewModel.getBranchForEdit()
        }
        headerLabel.text = articleDetailsViewModel.headerLabel.localized
        
    }
    
    func addImageToTextFields() {
        cityField.setRightImage(imageName: "icNext",textField: cityField)
        areaField.setRightImage(imageName: "icNext",textField: areaField)
    }
    
    func setLocationName() {
        guard let location = LocalStorage().getLocationName()  as? String , !location.isEmpty else {return}
        self.locationTextField.text = location
//        markLocationButton.setTitle(location, for: .normal)
    }
    
    func backTapped() {
        backButtonAction.rx.tap.subscribe { [weak self] _ in
            self?.router.backView()
        } .disposed(by: self.disposeBag)
        
    }
    
    func setUPForDelivery() {
        radioController.buttonsArray = [pharmacyDeliveryNo,pharmacyDeliveryYes]
        radioController.defaultButton = pharmacyDeliveryYes
        pharmacyDeliveryYesLabel.textColor = .blue
        pharmacyDeliveryNoLabel.textColor = .gray
        
    }
    
    func setUPForDeliveryServiceFeess() {
        radioControlleDeliveryFees.buttonsArray = [firstDeliveryTimeButton,secondDeliveryTimeButton,thirdDeliveryTimeButton]
        radioControlleDeliveryFees.defaultButton = firstDeliveryTimeButton
        
        firstDeliveryTimeLabel.textColor = .blue
        secondDeliveryTimeLabel.textColor = .gray
        thirdDeliveryTimeLabel.textColor = .gray

        
    }
    
    func setUPForPayment() {
        radioControllerPayment.buttonsArray = [paymentCashButton,paymentOnline]
        radioControllerPayment.defaultButton = paymentCashButton
        
    }
    
    func setUPForOpeingTime() {
        radioControllerOpeningtime.buttonsArray = [openingfullTime,openingCustomTime]
        radioControllerOpeningtime.defaultButton = openingfullTime
        openingFullTimeLabel.textColor = .blue
        fromTimeLabel.textColor = .gray
        
    }
    func setGesturesForCountry() {
        let country = UITapGestureRecognizer(target: self, action: #selector(CompleteRegisterViewController.tapCountry))
        countryField.isUserInteractionEnabled = true
        countryField.addGestureRecognizer(country)
    }
    
    func setGesturesForCity() {
        let city = UITapGestureRecognizer(target: self, action: #selector(CompleteRegisterViewController.tapCity))
        cityField.isUserInteractionEnabled = true
        cityField.addGestureRecognizer(city)
    }
    
    func setGesturesForArea() {
        let Area = UITapGestureRecognizer(target: self, action: #selector(CompleteRegisterViewController.tapArea))
        areaField.isUserInteractionEnabled = true
        areaField.addGestureRecognizer(Area)
    }
    
    
    func validateData() {
        articleDetailsViewModel.isValid.subscribe(onNext: {[weak self] (isEnabled) in
            isEnabled ? (self?.saveAction.isEnabled = true) : (self?.saveAction.isEnabled = false)
        }).disposed(by: self.disposeBag)
        
    }
    
    func ActionForOpeningFullTime() {
        openingfullTime.rx.tap.subscribe {[weak self] _ in
            self?.radioControllerOpeningtime.buttonArrayUpdated(buttonSelected: (self?.openingfullTime)!)
            self?.openingTime = true
            self?.chooseDateStackView.isHidden = true
            self?.openingFullTimeLabel.textColor = .blue
            self?.fromTimeLabel.textColor = .gray
        }.disposed(by: self.disposeBag)
        
    }
    
    func ActionForOpeningCustomtime() {
        openingCustomTime.rx.tap.subscribe {[weak self] _ in
            self?.radioControllerOpeningtime.buttonArrayUpdated(buttonSelected: (self?.openingCustomTime)!)
            self?.hasDelivery = false
            self?.chooseDateStackView.isHidden = false
            self?.openingFullTimeLabel.textColor = .gray
            self?.fromTimeLabel.textColor = .blue
        }.disposed(by: self.disposeBag)
    }
    
    func NoActionForDelivery() {
        pharmacyDeliveryNo.rx.tap.subscribe {[weak self] _ in
            self?.radioController.buttonArrayUpdated(buttonSelected: (self?.pharmacyDeliveryNo)!)
            self?.hasDelivery = false
            self?.enterFeesStackView.isHidden = true
            self?.enterFeesHeaderLabel.isHidden = true
            self?.enterFeesTime.isHidden = true
            self?.deliveryTimeStackView.isHidden = true
            self?.enterFeesTime.isHidden = true
            if self?.deliveryTime == .firstTime || self?.deliveryTime == .secondTime {
            self?.howFarTopConstraints.constant = -190
            }
            else {
                self?.howFarTopConstraints.constant = -200

            }
        }.disposed(by: self.disposeBag)
        
    }
    
    func yesActionForDelivery() {
        pharmacyDeliveryYes.rx.tap.subscribe {[weak self] _ in
            self?.radioController.buttonArrayUpdated(buttonSelected: (self?.pharmacyDeliveryYes)!)
            self?.hasDelivery = true
            self?.enterFeesStackView.isHidden = false
            self?.enterFeesHeaderLabel.isHidden = false
            self?.enterFeesTime.isHidden = false
            self?.deliveryTimeStackView.isHidden = false

            self?.howFarTopConstraints.constant = 10
        }.disposed(by: self.disposeBag)
    }
    
    
    func firstActionForDeloveryFees() {
        firstDeliveryTimeButton.rx.tap.subscribe {[weak self] _ in
            self?.radioControlleDeliveryFees.buttonArrayUpdated(buttonSelected: (self?.firstDeliveryTimeButton)!)
            self?.enterDeliveryTimeTextField.isHidden = true
            self?.firstDeliveryTimeLabel.textColor = .blue
            self?.secondDeliveryTimeLabel.textColor = .gray
            self?.thirdDeliveryTimeLabel.textColor = .gray
            self?.deliveryTime = .firstTime
        }.disposed(by: self.disposeBag)
        
    }
    
    func secondActionForDeloveryFees() {
        secondDeliveryTimeButton.rx.tap.subscribe {[weak self] _ in
            self?.radioControlleDeliveryFees.buttonArrayUpdated(buttonSelected: (self?.secondDeliveryTimeButton)!)
            self?.enterDeliveryTimeTextField.isHidden = true
            self?.firstDeliveryTimeLabel.textColor = .gray
            self?.secondDeliveryTimeLabel.textColor = .blue
            self?.thirdDeliveryTimeLabel.textColor = .gray
            self?.deliveryTime = .secondTime
        }.disposed(by: self.disposeBag)
    }
    
    func thirdDeliveryTimeAction() {
        thirdDeliveryTimeButton.rx.tap.subscribe {[weak self] _ in
            self?.radioControlleDeliveryFees.buttonArrayUpdated(buttonSelected: (self?.thirdDeliveryTimeButton)!)
            self?.enterDeliveryTimeTextField.isHidden = false
            self?.firstDeliveryTimeLabel.textColor = .gray
            self?.secondDeliveryTimeLabel.textColor = .gray
            self?.thirdDeliveryTimeLabel.textColor = .blue
            self?.deliveryTime = .thirdTime
        }.disposed(by: self.disposeBag)
    }
    
    func PaymentCash() {
        paymentCashButton.rx.tap.subscribe {[weak self] _ in
            self?.radioControllerPayment.buttonArrayUpdated(buttonSelected: (self?.paymentCashButton)!)
            self?.paymentWay = 1
        }.disposed(by: self.disposeBag)
        
    }
    
    func PaymentOnline() {
        paymentOnline.rx.tap.subscribe {[weak self] _ in
            self?.radioControllerPayment.buttonArrayUpdated(buttonSelected: (self?.paymentOnline)!)
            self?.paymentWay = 2
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
    
    func requestCountryList() {
        articleDetailsViewModel.getAllCountry()
    }
    
    func subscribeToCountry() {
        articleDetailsViewModel.countrySubject.subscribe {[weak self] country in
            self?.countryList = country.element!
        }.disposed(by: self.disposeBag)
    }
    
    func showFromDateAction() {
        fromDateButton.rx.tap.subscribe {[weak self] _ in
            self?.DatePickers.ShowPickerView(pickerView: self!, completionHandler: { date in
                self?.fromDateButton.setTitle(date, for: .normal)
            })
        } .disposed(by: self.disposeBag)
    }
    
    func showEndDateAction() {
        endDateButton.rx.tap.subscribe {[weak self] _ in
            self?.DatePickers.ShowPickerView(pickerView: self!, completionHandler: { date in
                self?.endDateButton.setTitle(date, for: .normal)
            })
        } .disposed(by: self.disposeBag)
        
    }
    
    func showAlert(message:String) {
        Alert().displayError(text: message, viewController: self)
    }
    
    func validateDataForSaveAndEditBranch() {
        if branchNameAr.text!.isEmpty || brnachNameEn.text!.isEmpty || mobileTextField.text!.isEmpty || cityField.text!.isEmpty || areaField.text!.isEmpty || landmarkAr.text!.isEmpty || landmarkEn.text!.isEmpty {
            showAlert(message: LocalizedStrings().emptyField)
        }
        
        else if mobileTextField.text!.count < 11 {
            showAlert(message: LocalizedStrings().unvalidemail)
        }

        else {
            sendDataToSave()
        }
    }
    
    func sendDataToSave(){
        if self.deliveryTime == .firstTime {
            deliveryTimes = 30
        }
        else if self.deliveryTime == .firstTime {
            deliveryTimes = 60
        }
        else {
            deliveryTimes = Int(self.enterDeliveryTimeTextField.text ?? "0") ?? 0
        }
        self.articleDetailsViewModel.saveEditPharmacy(HasDelivery: self.hasDelivery , TwintyFourHoursService: self.openingTime , paymentType: self.paymentWay , selectedCountry: self.countrySelected , selectedCity: self.citySelected, selectedArea: self.areaSelected, DeliveryFees:Int(enterFeesField.text ?? "0") ?? 0 , DeliveryTimeInMinuts:deliveryTimes ,ClosingTime: (endDateButton.titleLabel?.text ?? "") , OpeninigTime:(fromDateButton.titleLabel?.text ?? ""))
    }
    
    func saveTapped() {
        saveAction.rx.tap.subscribe { [weak self] _ in
            self?.validateDataForSaveAndEditBranch()
        } .disposed(by: self.disposeBag)
        
    }
    
    func subsribeEditBranch() {
        articleDetailsViewModel.EditBranchInstance.subscribe { [weak self] editBranch in
            if let editBranch = editBranch.element {
                DispatchQueue.main.async {
                    self?.countrySelected = editBranch.countryID ?? 0
                    self?.citySelected = editBranch.cityID ?? 0
                    self?.areaSelected = editBranch.areaID ?? 0
                    self?.paymentWay = editBranch.paymentType ?? 0
                    self?.hasDelivery = editBranch.hasDelivery ?? false
                    self?.openingTime = editBranch.twintyFourHoursService ?? false
                    self?.branchNameAr.text = editBranch.branchNameAr
                    self?.brnachNameEn.text = editBranch.branchNameEn
                    self?.mobileTextField.text = editBranch.mobileNumber
                    self?.countryField.text = "Egypt".localized
                    self?.cityField.text = editBranch.cityName
                    self?.areaField.text = editBranch.areaName
//                    self?.streetNameAr.text = editBranch.address
//                    self?.streetNameEn.text = editBranch.address
                    LocalStorage().saveLocationName(locationName: editBranch.address ?? "")
                    let lon = Double(editBranch.lang ?? "")
                    let lat = Double(editBranch.lat ?? "")
                    LocalStorage().saveLocationLatitude(latitude: lat ?? 0.0)
                    LocalStorage().saveLocationLogitude(longtitude: lon ?? 0.0)
                    self?.landmarkAr.text = editBranch.landMarkAr
                    self?.landmarkEn.text = editBranch.landMarkEn
                    
                    self?.kilometerField.text = "\(editBranch.provideServiceInKM ?? 0)"
                    self?.bindAllTextFields()
                }
            }
        }.disposed(by: self.disposeBag)
        
    }
    
    func bindAllTextFields(){
        bindbrnachNameEn()
        bindbranchNameAr()
        bindmobile()
        bindcityField()
        bindareaField()
//        bindstreetNameEn()
//        bindstreetNameAr()
//        bindbuildingNameEn()
//        bindbuildingNameAr()
        bindlandmarkEn()
        bindlandmarkAr()
        bindhowFarService()
    }
}

extension AddPharmacyViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}


extension AddPharmacyViewController {
    
    func bindbrnachNameEn() {
        brnachNameEn.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.brnachNameEn).disposed(by: self.disposeBag)
    }
    
    func bindbranchNameAr() {
        branchNameAr.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.brnachNameAr).disposed(by: self.disposeBag)
    }
    
    func bindmobile() {
        mobileTextField.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.mobile).disposed(by: self.disposeBag)
    }
    
    func bindcityField() {
        cityField.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.city).disposed(by: self.disposeBag)
    }
    
    func bindareaField() {
        areaField.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.area).disposed(by: self.disposeBag)
    }
    
    
    
    
//    func bindstreetNameEn() {
//        streetNameEn.rx.text
//            .orEmpty
//            .bind(to: articleDetailsViewModel.streetNameEn).disposed(by: self.disposeBag)
//    }
//
//    func bindstreetNameAr() {
//        streetNameAr.rx.text
//            .orEmpty
//            .bind(to: articleDetailsViewModel.streetNameAr).disposed(by: self.disposeBag)
//    }
//
//    func bindbuildingNameEn() {
//        buildingNameEn.rx.text
//            .orEmpty
//            .bind(to: articleDetailsViewModel.buildinghNameEn).disposed(by: self.disposeBag)
//    }
//
//    func bindbuildingNameAr() {
//        buildingNameAr.rx.text
//            .orEmpty
//            .bind(to: articleDetailsViewModel.buildingNameAr).disposed(by: self.disposeBag)
//    }
    
    func bindlandmarkEn() {
        landmarkEn.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.landmarkeEn).disposed(by: self.disposeBag)
    }
    func bindlandmarkAr() {
        landmarkAr.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.landmarkAr).disposed(by: self.disposeBag)
    }
    
    func bindhowFarService() {
        kilometerField.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.howFarService).disposed(by: self.disposeBag)
    }
    
    
}
extension AddPharmacyViewController {
    func showMapView() {
        markLocationButton.rx.tap.subscribe { [weak self] _ in
            self?.articleDetailsViewModel.pushNextView()
        }.disposed(by: self.disposeBag)
        
    }
}

extension AddPharmacyViewController {
    @objc
    func tapCountry(sender:UITapGestureRecognizer) {
        
        selectCityFromDropDown.anchorView = countryField
        selectCityFromDropDown.direction = .any
        selectCityFromDropDown.backgroundColor = UIColor.white
        selectCityFromDropDown.bottomOffset = CGPoint(x: 0, y:(selectCityFromDropDown.anchorView?.plainView.bounds.height)!)
        let country = countryList.map({($0.countryNameEn ?? "") })
        let countryIds = countryList.map({($0.countryID ?? 0) })
        self.selectCityFromDropDown.dataSource = country
        selectCityFromDropDown.show()
        // Action triggered on selection
        
        selectCityFromDropDown.selectionAction = { [weak self] (index, item) in
            
            self?.countryField.text = item
            self?.countrySelected = countryIds[index]
            self?.countrySelectedIndex =  index
            
        }
        
    }
    
    @objc
    func tapCity(sender:UITapGestureRecognizer) {
        
        selectCityFromDropDown.anchorView = cityField
        selectCityFromDropDown.direction = .any
        selectCityFromDropDown.backgroundColor = UIColor.white
        selectCityFromDropDown.bottomOffset = CGPoint(x: 0, y:(selectCityFromDropDown.anchorView?.plainView.bounds.height)!)
        let city = countryList[countrySelectedIndex].lookupCity ?? []
        let cityName = city.map({($0.cityNameEn ?? "") })
        let cityIds = city.map({($0.cityID ?? 0) })
        self.selectCityFromDropDown.dataSource =  cityName
        selectCityFromDropDown.show()
        // Action triggered on selection
        
        selectCityFromDropDown.selectionAction = { [weak self] (index, item) in
            
            self?.cityField.text = item
            self?.citySelected = cityIds[index]
            self?.citySelectedIndex = index
        }
        
    }
    
    @objc
    func tapArea(sender:UITapGestureRecognizer) {
        
        selectCityFromDropDown.anchorView = areaField
        selectCityFromDropDown.direction = .any
        selectCityFromDropDown.backgroundColor = UIColor.white
        selectCityFromDropDown.bottomOffset = CGPoint(x: 0, y:(selectCityFromDropDown.anchorView?.plainView.bounds.height)!)
        let area = countryList[countrySelectedIndex].lookupCity?[citySelectedIndex].lookupArea ?? []
        let areaName = area.map({($0.areaNameEn ?? "") })
        let areaIds = area.map({($0.areaID ?? 0) })
        self.selectCityFromDropDown.dataSource = areaName
        selectCityFromDropDown.show()
        // Action triggered on selection
        
        selectCityFromDropDown.selectionAction = { [weak self] (index, item) in
            
            self?.areaField.text = item
            self?.areaSelected = areaIds[index]
        }
        
    }
}
