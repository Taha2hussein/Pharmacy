//
//  CompleteRegisterViewController.swift
//  Pharmacy
//
//  Created by A on 07/01/2022.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import DropDown

class CompleteRegisterViewController: BaseViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var yesLabel: UILabel!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var locationMapField: UITextField!
    @IBOutlet weak var createAccount: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var uploadPhotoButton: UIButton!
    @IBOutlet weak var collectionView_Images: UICollectionView!
    @IBOutlet weak var pharmacyImage: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var pharmacyStreetName: UITextField!
    @IBOutlet weak var pharmacyArea: UITextField!
    @IBOutlet weak var pharmacyCity: UITextField!
    @IBOutlet weak var pharmacyName: UITextField!
    @IBOutlet weak var pharmacyCountry: UITextField!
    @IBOutlet weak var pharmacyBranch: UITextField!
    @IBOutlet weak var testImage: UIImageView!
    @IBOutlet weak var licenesCollectionView: UICollectionView!
    
    private var chooseImaageSelection = false
    private var countrySelectedIndex = -1
    private var citySelectedIndex = -1
    private var countrySelected = 0
    private var citySelected = 0
    private var areaSelected = 0
    private var hasDelivery = false
    private var pharmacyImagePath = ""
    let radioController: RadioButtonController = RadioButtonController()
    private var countryList = [CountryMessage]()
    var articleDetailsViewModel = CompleteRegisterViewModel()
    private var router = CompleteRegisterRouter()
    private var licenseImage = [String]()
    lazy var dropDowns: DropDown = {
        return self.selectCityFromDropDown
    }()
    let selectCityFromDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUP()
        selectImageTappedForPharmacy()
        selectImageTappedForLicesne()
        bindImageToPharmcyImage()
        bindViewControllerRouter()
        showMapView()
        subscribeToLoader()
        requestCountryList()
        setGesturesForCountry()
        subscribeToCountry()
        setGesturesForCity()
        setGesturesForArea()
        backAction()
        NoAction()
        yesAction()
        bindImagesToCollection()
        subscribeToCreateAccount()
        bindImageToPharmacy()
//        setUpPhone()
        addImageToTextFields()
        subscribeToLoaderForImageUpload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLocationName()
    }
    
    func setUP() {
        radioController.buttonsArray = [noButton,yesButton]
        radioController.defaultButton = yesButton
        noLabel.textColor = .gray
        yesLabel.textColor = .blue
    }
    
    
    func addImageToTextFields() {
        
        pharmacyCountry.setRightImage(imageName: "icNext",textField: pharmacyCountry)
        pharmacyCity.setRightImage(imageName: "icNext",textField: pharmacyCity)
        pharmacyArea.setRightImage(imageName: "icNext",textField: pharmacyArea)
    }
    
    func setLocationName() {
        guard let location = LocalStorage().getLocationName()  as? String , !location.isEmpty else {return}
        locationMapField.text = location
    }
    
    func selectImageTappedForLicesne() {
        
        uploadPhotoButton.rx.tap.subscribe { [weak self] _ in
            //            self?.chooseImaageSelection = false
            //            self?.useWPmediaPicker()
            ImagePickerManager().pickImage(self!){[weak self] image in
                
                guard var license = try? self?.articleDetailsViewModel.selectedImagesForLicence.value() else { return }
                license.append(image)
                self?.articleDetailsViewModel.selectedImagesForLicence.onNext(license)
                self?.uploadImageForLicense(image: image)
            }
        }.disposed(by: self.disposeBag)
        
    }
    
    func backAction() {
        backButton.rx.tap.subscribe { [weak self] _ in
            self?.router.backView()
        } .disposed(by: self.disposeBag)
        
    }
    
    func uploadImageForLicense(image: UIImage) {
        let compresedImage = UploadDataa(data: image.jpegData(compressionQuality: 0.1)!, Key: "personal_image")
        AlamofireMultiPart.shared.PostMultiWithModel(model: SuccessModelImage.self, url: uploadImageApi, Images: [compresedImage], header: headers, parameters: [:],completion: self.ProfileImageNetworkForLicense)
    }
    
    func selectImageTappedForPharmacy() {
        
        pharmacyImage.rx.tap.subscribe { [weak self] _ in
            ImagePickerManager().pickImage(self!){[weak self] image in
                self?.pharmacyImage.setImage(image, for: .normal)
                self?.articleDetailsViewModel.selectedImageOwner.onNext(image)
                
            }
        }.disposed(by: self.disposeBag)
        
    }
    
    func bindImageToPharmacy() {
        articleDetailsViewModel.selectedImageOwner.subscribe {[weak self] image in
            if let image = image.element {
                let compresedImage = UploadDataa(data: image.jpegData(compressionQuality: 0.1)!, Key: "personal_image")
                AlamofireMultiPart.shared.PostMultiWithModel(model: SuccessModelImage.self, url: uploadImageApi, Images: [compresedImage], header: headers, parameters: [:],completion: self!.ProfileImageNetwork)
                
            }
        }.disposed(by: self.disposeBag)
        
    }
    
    func bindImageToPharmcyImage() {
        //        self.articleDetailsViewModel.selectedImagePharmacy.subscribe {[weak self] assets in
        //            self?.pharmacyImage.setImage(assets.image, for: .normal)
        //        } .disposed(by: self.disposeBag)
    }
    
    func bindImagesToCollection() {
        self.articleDetailsViewModel.selectedImagesForLicence
            .bind(to: self.licenesCollectionView
                .rx
                .items(cellIdentifier: String(describing:  ImagesCollectionViewCell.self),
                       cellType: ImagesCollectionViewCell.self)) { row, model, cell in
                cell.licesnesImage.image = model
            }.disposed(by: self.disposeBag)
    }
    
    func requestCountryList() {
        articleDetailsViewModel.getAllCountry()
    }
    
    func subscribeToCountry() {
        articleDetailsViewModel.countrySubject.subscribe {[weak self] country in
            self?.countryList = country.element!
        }.disposed(by: self.disposeBag)
    }
    
    func showAlert(message:String) {
        Alert().displayError(text: message, viewController: self)
    }
    
    func validateALLField() {
        if pharmacyName.text!.isEmpty || pharmacyBranch.text!.isEmpty || pharmacyStreetName.text!.isEmpty || locationMapField.text!.isEmpty {
            showAlert(message: LocalizedStrings().emptyField)
        }
        
        else if pharmacyBranch.text!.count < 3 ||  pharmacyBranch.text!.count > 75  {
            showAlert(message: LocalizedStrings().brnachNameError)
        }
        
        else if pharmacyImagePath == "" {
            showAlert(message: LocalizedStrings().uploadImage)
        }
        
        else if licenseImage.count == 0 {
            showAlert(message: LocalizedStrings().licenceError)

        }
        else {
            defer {
                self.articleDetailsViewModel.register()
            }
            self.setDataForRegister()
            
        }
        
    }
    
    
    func subscribeToCreateAccount() {
        createAccount.rx.tap.subscribe { [weak self] _ in
            
            self?.validateALLField()
           
        } .disposed(by: self.disposeBag)
        
    }
    
    
    func setDataForRegister() {
        let LocalStorage = LocalStorage()
        
        let register = RegisterParameters(
            firstName: LocalStorage.getownerFirstName(),
            lastName: LocalStorage.getownerLastName(),
            email: LocalStorage.getownerEmail(),
            password: LocalStorage.getOwnerPassword(),
            countryCode: "02",
            phoneNumber: LocalStorage.getownerPhone(),
            ownerImage: articleDetailsViewModel.ownerImagePath ?? "",
            pharmacyImage: pharmacyImagePath,
            pharmacyName: self.pharmacyName.text ?? "",
            country: self.countrySelected ,
            adress: self.pharmacyStreetName.text ?? "" ,
            branch: self.pharmacyBranch.text ?? "",
            city: self.citySelected ,
            area: self.areaSelected ,
            streetName: self.pharmacyStreetName.text ?? "",
            locationName: LocalStorage.getLocationName(),
            locationLatitude: LocalStorage.getlocationLatitude(),
            locationLongitude: LocalStorage.getLocationLongituded(),
            licens: self.licenseImage,
            hasDelivery: self.hasDelivery
        )
        self.articleDetailsViewModel.registerParamerters = register
        
        
        
        
    }
    
    func subscribeToLoaderForImageUpload() {
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
    
    func NoAction() {
        noButton.rx.tap.subscribe {[weak self] _ in
            self?.radioController.buttonArrayUpdated(buttonSelected: (self?.noButton)!)
            self?.hasDelivery = false
            self?.noLabel.textColor = .blue
            self?.yesLabel.textColor = .gray
        }.disposed(by: self.disposeBag)
        
    }
    
    func yesAction() {
        yesButton.rx.tap.subscribe {[weak self] _ in
            self?.radioController.buttonArrayUpdated(buttonSelected: (self?.yesButton)!)
            self?.hasDelivery = true
            self?.noLabel.textColor = .gray
            self?.yesLabel.textColor = .blue
        }.disposed(by: self.disposeBag)
    }
    
    func setGesturesForCountry() {
        let country = UITapGestureRecognizer(target: self, action: #selector(CompleteRegisterViewController.tapCountry))
        pharmacyCountry.isUserInteractionEnabled = true
        pharmacyCountry.addGestureRecognizer(country)
    }
    
    func setGesturesForCity() {
        let city = UITapGestureRecognizer(target: self, action: #selector(CompleteRegisterViewController.tapCity))
        pharmacyCity.isUserInteractionEnabled = true
        pharmacyCity.addGestureRecognizer(city)
    }
    
    func setGesturesForArea() {
        let Area = UITapGestureRecognizer(target: self, action: #selector(CompleteRegisterViewController.tapArea))
        pharmacyArea.isUserInteractionEnabled = true
        pharmacyArea.addGestureRecognizer(Area)
    }
    
    
}

extension CompleteRegisterViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}

extension CompleteRegisterViewController {
    func showMapView() {
        locationButton.rx.tap.subscribe { [weak self] _ in
            self?.articleDetailsViewModel.pushNextView()
        }.disposed(by: self.disposeBag)
        
    }
}

extension CompleteRegisterViewController {
    @objc
    func tapCountry(sender:UITapGestureRecognizer) {
        citySelectedIndex = -1
        
        selectCityFromDropDown.anchorView = pharmacyCountry
        selectCityFromDropDown.direction = .any
        selectCityFromDropDown.backgroundColor = UIColor.white
        selectCityFromDropDown.bottomOffset = CGPoint(x: 0, y:(selectCityFromDropDown.anchorView?.plainView.bounds.height)!)
        let country = countryList.map({($0.countryNameEn ?? "") })
        let countryIds = countryList.map({($0.countryID ?? 0) })
        self.selectCityFromDropDown.dataSource = country
        selectCityFromDropDown.show()
        // Action triggered on selection
        
        selectCityFromDropDown.selectionAction = { [weak self] (index, item) in
            
            self?.pharmacyCountry.text = item
            self?.countrySelected = countryIds[index]
            self?.countrySelectedIndex =  index
            
        }
        
    }
    
    @objc
    func tapCity(sender:UITapGestureRecognizer) {
        //        citySelectedIndex = -1
        selectCityFromDropDown.anchorView = pharmacyCity
        selectCityFromDropDown.direction = .any
        selectCityFromDropDown.backgroundColor = UIColor.white
        selectCityFromDropDown.bottomOffset = CGPoint(x: 0, y:(selectCityFromDropDown.anchorView?.plainView.bounds.height)!)
        guard countrySelectedIndex != -1 else {return}
        if let city = countryList[countrySelectedIndex].lookupCity {
            let cityName = city.map({($0.cityNameEn ?? "") })
            let cityIds = city.map({($0.cityID ?? 0) })
            self.selectCityFromDropDown.dataSource =  cityName
            selectCityFromDropDown.show()
            // Action triggered on selection
            
            selectCityFromDropDown.selectionAction = { [weak self] (index, item) in
                
                self?.pharmacyCity.text = item
                self?.citySelected = cityIds[index]
                self?.citySelectedIndex = index
            }
        }
    }
    
    @objc
    func tapArea(sender:UITapGestureRecognizer) {
        
        selectCityFromDropDown.anchorView = pharmacyArea
        selectCityFromDropDown.direction = .any
        selectCityFromDropDown.backgroundColor = UIColor.white
        selectCityFromDropDown.bottomOffset = CGPoint(x: 0, y:(selectCityFromDropDown.anchorView?.plainView.bounds.height)!)
        guard citySelectedIndex != -1 else {return}
        if let area = countryList[countrySelectedIndex].lookupCity?[citySelectedIndex].lookupArea {
            let areaName = area.map({($0.areaNameEn ?? "") })
            let areaIds = area.map({($0.areaID ?? 0) })
            self.selectCityFromDropDown.dataSource = areaName
            selectCityFromDropDown.show()
            // Action triggered on selection
            
            selectCityFromDropDown.selectionAction = { [weak self] (index, item) in
                
                self?.pharmacyArea.text = item
                self?.areaSelected = areaIds[index]
            }
        }
    }
}

extension CompleteRegisterViewController {
    func ProfileImageNetwork(result : ServerResponse<SuccessModelImage>){
        switch result {
        case .success(let model):
            if model.successtate == 200 {
                self.pharmacyImagePath = model.message ?? ""
                print(model.message ?? "","model.messages")
            }else{
                print("model: \(model)")
                Alert().displayError(text: model.errormessage ?? "An error occured , Please try again".localized, viewController: self)
            }
            break
        case .failure(let err):
            guard let err = err else {return}
            print("err: \(err)")
        }
    }
    
    
    func ProfileImageNetworkForLicense(result : ServerResponse<SuccessModelImage>){
        switch result {
        case .success(let model):
            if model.successtate == 200 {
                self.licenseImage.append(model.message ?? "")
                print(model.message ?? "","model.messages")
            }else{
                print("model: \(model)")
                Alert().displayError(text: model.errormessage ?? "An error occured , Please try again".localized, viewController: self)
            }
            break
        case .failure(let err):
            guard let err = err else {return}
            print("err: \(err)")
        }
    }
}
