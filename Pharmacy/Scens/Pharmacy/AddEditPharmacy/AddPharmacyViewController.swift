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
class AddPharmacyViewController: BaseViewController {
    
    @IBOutlet weak var backButtonAction: UIButton!
    @IBOutlet weak var markLocationButton: UIButton!
    @IBOutlet weak var kilometerField: UITextField!
    @IBOutlet weak var openingCustomTime: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    @IBOutlet weak var fromDateButton: UIButton!
    @IBOutlet weak var chooseDateStackView: UIStackView!
    @IBOutlet weak var openingfullTime: UIButton!
    @IBOutlet weak var deliveryFessNo: UIButton!
    @IBOutlet weak var deliveryFeesYes: UIButton!
    @IBOutlet weak var paymentOnline: UIButton!
    @IBOutlet weak var paymentCashButton: UIButton!
    @IBOutlet weak var pharmacyDeliveryNo: UIButton!
    @IBOutlet weak var pharmacyDeliveryYes: UIButton!
    @IBOutlet weak var landmarkAr: UITextField!
    @IBOutlet weak var landmarkEn: UITextField!
    @IBOutlet weak var buildingNameAr: UITextField!
    @IBOutlet weak var buildingNameEn: UITextField!
    @IBOutlet weak var streetNameAr: UITextField!
    @IBOutlet weak var streetNameEn: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var areaField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var branchNameAr: UITextField!
    @IBOutlet weak var brnachNameEn: UITextField!
    @IBOutlet weak var saveAction: UIButton!
    @IBOutlet weak var countryField: UITextField!
    
    var articleDetailsViewModel = AddPharmacyViewModel()
    private var router = AddPharmacyRouter()
    private var DatePickers = DatePicker()
    private var hasDelivery = false
    private var deliveryFees = false
    private var openingTime = false
    private var paymentWay: Int = 1
    private var countrySelectedIndex = 0
    private var citySelectedIndex = 0
    private var countrySelected = 0
    private var citySelected = 0
    private var areaSelected = 0

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
        bindbrnachNameEn()
        bindbranchNameAr()
        bindmobile()
        bindcityField()
        bindareaField()
        bindstreetNameEn()
        bindstreetNameAr()
        bindbuildingNameEn()
        bindbuildingNameAr()
        bindlandmarkEn()
        bindlandmarkAr()
        bindhowFarService()
        showFromDateAction()
        subscribeToLoader()
        NoActionForDelivery()
        yesActionForDelivery()
        NoActionForDeloveryFees()
        YesActionForDeloveryFees()
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLocationName()
    }
    
    func setLocationName() {
        guard let location = LocalStorage().getLocationName()  as? String , !location.isEmpty else {return}
        markLocationButton.setTitle(location, for: .normal)
    }
    
    func backTapped() {
        backButtonAction.rx.tap.subscribe { [weak self] _ in
            self?.router.backView()
        } .disposed(by: self.disposeBag)

    }
    
    func setUPForDelivery() {
        radioController.buttonsArray = [pharmacyDeliveryNo,pharmacyDeliveryYes]
        radioController.defaultButton = pharmacyDeliveryNo

    }
    
    func setUPForDeliveryServiceFeess() {
        radioControlleDeliveryFees.buttonsArray = [deliveryFessNo,deliveryFeesYes]
        radioControlleDeliveryFees.defaultButton = deliveryFessNo

    }
    
    func setUPForPayment() {
        radioControllerPayment.buttonsArray = [paymentCashButton,paymentOnline]
        radioControllerPayment.defaultButton = paymentCashButton

    }
    
    func setUPForOpeingTime() {
        radioControllerOpeningtime.buttonsArray = [openingfullTime,openingCustomTime]
        radioControllerOpeningtime.defaultButton = openingfullTime

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
        }.disposed(by: self.disposeBag)
        
    }
    
    func ActionForOpeningCustomtime() {
        openingCustomTime.rx.tap.subscribe {[weak self] _ in
            self?.radioControllerOpeningtime.buttonArrayUpdated(buttonSelected: (self?.openingCustomTime)!)
            self?.hasDelivery = false
            self?.chooseDateStackView.isHidden = false
        }.disposed(by: self.disposeBag)
    }

    func NoActionForDelivery() {
        pharmacyDeliveryNo.rx.tap.subscribe {[weak self] _ in
            self?.radioController.buttonArrayUpdated(buttonSelected: (self?.pharmacyDeliveryNo)!)
            self?.hasDelivery = false
        }.disposed(by: self.disposeBag)
        
    }
    
    func yesActionForDelivery() {
        pharmacyDeliveryYes.rx.tap.subscribe {[weak self] _ in
            self?.radioController.buttonArrayUpdated(buttonSelected: (self?.pharmacyDeliveryYes)!)
            self?.hasDelivery = true
        }.disposed(by: self.disposeBag)
    }
    
    
    func NoActionForDeloveryFees() {
        deliveryFessNo.rx.tap.subscribe {[weak self] _ in
            self?.radioControlleDeliveryFees.buttonArrayUpdated(buttonSelected: (self?.deliveryFessNo)!)
            self?.deliveryFees = false
        }.disposed(by: self.disposeBag)
        
    }
    
    func YesActionForDeloveryFees() {
        deliveryFeesYes.rx.tap.subscribe {[weak self] _ in
            self?.radioControlleDeliveryFees.buttonArrayUpdated(buttonSelected: (self?.deliveryFeesYes)!)
            self?.deliveryFees = true
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
    
    func saveTapped() {
        saveAction.rx.tap.subscribe { [weak self] _ in
            self?.articleDetailsViewModel.saveEditPharmacy(HasDelivery: self?.hasDelivery ?? true, TwintyFourHoursService: self?.openingTime ?? true, paymentType: self?.paymentWay ?? 0, selectedCountry: self?.countrySelected ?? 0, selectedCity: self?.citySelected ?? 0, selectedArea: self?.areaSelected ?? 0)
        } .disposed(by: self.disposeBag)

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
    
    
    
    
    func bindstreetNameEn() {
        streetNameEn.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.streetNameEn).disposed(by: self.disposeBag)
    }
    
    func bindstreetNameAr() {
        streetNameAr.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.streetNameAr).disposed(by: self.disposeBag)
    }
    
    func bindbuildingNameEn() {
        buildingNameEn.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.buildinghNameEn).disposed(by: self.disposeBag)
    }
    
    func bindbuildingNameAr() {
        buildingNameAr.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.buildingNameAr).disposed(by: self.disposeBag)
    }
    
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
