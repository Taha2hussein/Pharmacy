//
//  CompleteRegisterViewController.swift
//  Pharmacy
//
//  Created by A on 07/01/2022.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay
import DropDown
import WPMediaPicker

class CompleteRegisterViewController: BaseViewController {
    
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
    private var Images = [ZTAssetWrapper]()
    private var countrySelectedIndex = 0
    private var citySelectedIndex = 0
    private var countrySelected = 0
    private var citySelected = 0
    private var areaSelected = 0
    private var hasDelivery = false

    let radioController: RadioButtonController = RadioButtonController()
    private var countryList = [CountryMessage]()
    var articleDetailsViewModel = CompleteRegisterViewModel()
    private var router = CompleteRegisterRouter()
    
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
        NoAction()
        yesAction()
        bindImagesToCollection()
        subscribeToCreateAccount()
    }
    
    func setUP() {
        radioController.buttonsArray = [noButton,yesButton]
        radioController.defaultButton = noButton
    }
    
    func selectImageTappedForLicesne() {
        
        uploadPhotoButton.rx.tap.subscribe { [weak self] _ in
            self?.chooseImaageSelection = false
            self?.useWPmediaPicker()
        }.disposed(by: self.disposeBag)
        
    }
    
    func selectImageTappedForPharmacy() {
        
        pharmacyImage.rx.tap.subscribe { [weak self] _ in
            self?.chooseImaageSelection = true
            self?.useWPmediaPicker()
        }.disposed(by: self.disposeBag)
        
    }
    
    func bindImageToPharmcyImage(){
        self.articleDetailsViewModel.selectedImagePharmacy.subscribe {[weak self] assets in
            self?.pharmacyImage.setImage(assets.image, for: .normal)
        } .disposed(by: self.disposeBag)
    }
    
    func bindImagesToCollection() {
        self.articleDetailsViewModel.selectedImages
            .bind(to: self.licenesCollectionView
                    .rx
                    .items(cellIdentifier: String(describing:  ImagesCollectionViewCell.self),
                           cellType: ImagesCollectionViewCell.self)) { row, model, cell in
                cell.licesnesImage.image = model?.image
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
    
    func subscribeToCreateAccount() {
        createAccount.rx.tap.subscribe { [weak self] _ in
            defer {
                self?.articleDetailsViewModel.register()
            }
            self?.setDataForRegister()
        } .disposed(by: self.disposeBag)
        
    }
    
    func setDataForRegister() {
        let LocalStorage = LocalStorage()
        
        var parameters = [String]()
        
        parameters.append("test.png")
        let pharmacyimage = getPharmacyImage()
        
        let register = RegisterParameters(
            firstName: LocalStorage.getownerFirstName(),
            lastName: LocalStorage.getownerLastName(),
            email: LocalStorage.getownerEmail(),
            password: LocalStorage.getOwnerPassword(),
            countryCode: "02",
            phoneNumber: LocalStorage.getownerPhone(),
            ownerImage: "test.png",
            pharmacyImage: pharmacyimage,
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
            licens: parameters,
            hasDelivery: self.hasDelivery
        )
        
        self.articleDetailsViewModel.registerParamerters = register
        
    }
    
    func getPharmacyImage() -> String {
        let image = pharmacyImage.currentImage
        let pharmacyImage = ImageConvert().convertImageToBase64(image: (image  ?? UIImage(named: "Avatar"))!)
        return pharmacyImage
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
        }.disposed(by: self.disposeBag)
        
    }
    
    func yesAction() {
        yesButton.rx.tap.subscribe {[weak self] _ in
            self?.radioController.buttonArrayUpdated(buttonSelected: (self?.yesButton)!)
            self?.hasDelivery = true
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
    
    func useWPmediaPicker() {
        let options =  WPMediaPickerOptions()
        options.filter = .image
        options.allowMultipleSelection = true
        options.showMostRecentFirst = true
        options.allowCaptureOfMedia = false
        let picker = WPNavigationMediaPickerViewController(options: options )
        picker.modalPresentationStyle = .fullScreen
        picker.delegate = self
        self.present(picker, animated: true)
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
        
        selectCityFromDropDown.anchorView = pharmacyCity
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
            
            self?.pharmacyCity.text = item
            self?.citySelected = cityIds[index]
            self?.citySelectedIndex = index
        }
        
    }
    
    @objc
    func tapArea(sender:UITapGestureRecognizer) {
        
        selectCityFromDropDown.anchorView = pharmacyArea
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
            
            self?.pharmacyArea.text = item
            self?.areaSelected = areaIds[index]
            //            self?.citySelected = index
        }
        
    }
}


extension CompleteRegisterViewController: WPMediaPickerViewControllerDelegate {
    private func mediaPickerController(_ picker: WPMediaPickerViewController?, previewViewControllerForAssets assets: [WPMediaAsset?]?, selectedIndex selected: Int) {
        
    }
    
    func mediaPickerController(_ picker: WPMediaPickerViewController, didFinishPicking assets: [WPMediaAsset]) {
        picker.dismiss(animated: true, completion: nil)
        
        for (_ , element ) in assets.enumerated() {
            
            if element.assetType() == .image  {
                element.image(with: CGSize(width: 100, height: 100), completionHandler: { image, err in
                    
                    let selectedImage = ZTAssetWrapper(url: nil, type: .image, avAssetUrl: nil, image: image)
                    if self.Images.count > 1 {
                        self.Images.removeFirst()
                    }
                    //
                    
                    if self.chooseImaageSelection {
                        self.articleDetailsViewModel.selectedImagePharmacy.onNext(selectedImage)
                    }
                    
                    else{
                        self.Images.append(selectedImage)
                        self.articleDetailsViewModel.selectedImages.onNext(self.Images)
                    }
                }
                )
                
            }
        }
    }
    
}
struct ZTAssetWrapper {
    var url : URL?
    var type : ZTMediaType
    var avAssetUrl : AVURLAsset?
    var image : UIImage?
}

enum ZTMediaType {
    case audio
    case image
    case video
}
