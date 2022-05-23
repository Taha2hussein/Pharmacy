//
//  BasicDataViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 23/04/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import SDWebImage
class BasicDataViewController: BaseViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var changeProfileButton: UIButton!
    @IBOutlet weak var savebutton: UIButton!
    @IBOutlet weak var pharmcyNameAr: UITextField!
    @IBOutlet weak var uploadFilesButton: UIButton!
    @IBOutlet weak var respondTimeField: UITextField!
    @IBOutlet weak var aboutPharmacyAr: UITextField!
    @IBOutlet weak var aboutPharmacyEn: UITextField!
    @IBOutlet weak var pharmacyNameEn: UITextField!
    @IBOutlet weak var pharmacyImage: UIImageView!
    @IBOutlet weak var filesCollectionView: UICollectionView!
    
    var articleDetailsViewModel = BasicDataViewModel()
    private var router = BasicDataRouter()
    private var BasicDataResponse : BasicDataMessage?
    private var files = [String]()
    private var profileImagePath = ""
    private var licenseImage = [File]()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        bindfilesToCollectionview()
        subscribeToLoader()
        bindBasicData()
        saveUpdatedBasicData()
        subscribeToLoaderForImage()
        bindImageToOwnerImage()
        selectImageTappedForOwner()
        backButtonAction()
        selectImageTappedForLicesne()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        articleDetailsViewModel.getBasicData()
    }
    
    func bindfilesToCollectionview() {
        articleDetailsViewModel.Files
            .bind(to: self.filesCollectionView
                .rx
                .items(cellIdentifier: String(describing:  BasicDataFilesCollectionViewCell.self),
                       cellType: BasicDataFilesCollectionViewCell.self)) { row, model, cell in
                cell.setFile(modle:model)
                
                cell.deleteButtons.rx.tap.subscribe { [weak self] _ in
                    guard var files = try? self?.articleDetailsViewModel.Files.value() else { return }
                    files.remove(at: row)

                    self?.articleDetailsViewModel.Files.onNext(files)
                } .disposed(by: cell.bag)

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

    func bindBasicData() {
        articleDetailsViewModel.basicData.subscribe {[weak self] basicDat in
            if let basicData = basicDat.element?.message {
                DispatchQueue.main.async {
                self?.pharmacyNameEn.text = basicData.pharmacyNameEn
                self?.pharmcyNameAr.text = basicData.pharmacyNameAr
                self?.aboutPharmacyEn.text = basicData.aboutThePharmacyEn
                self?.aboutPharmacyAr.text = basicData.aboutThePharmacyAr
                self?.respondTimeField.text = "\(basicData.timeToRespondTheOrderInHours ?? 0)"
                if let url = URL(string: baseURLImage + (basicData.image ?? "")) {
//                    self?.pharmacyImage.load(url: url)
                    self?.pharmacyImage.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar"))

                  }
                }
            }
        }.disposed(by: self.disposeBag)

    }
    
    func backButtonAction(){
        backButton.rx.tap.subscribe { [weak self] _ in
            self?.router.backAction()
        } .disposed(by: self.disposeBag)

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
        
        changeProfileButton.rx.tap.subscribe { [weak self] _ in
            self?.useWPmediaPicker()
        }.disposed(by: self.disposeBag)
        
    }
    
    func bindImageToOwnerImage() {
        articleDetailsViewModel.selectedImageOwner.subscribe {[weak self] image in
            if let image = image.element {
                DispatchQueue.main.async {
                    self?.pharmacyImage.image = image
                    let comperesImage = UploadDataa(data: image.jpegData(compressionQuality: 0.1)!, Key: "personal_image")
                    AlamofireMultiPart.shared.PostMultiWithModel(model: SuccessModelImage.self, url: uploadImageApi, Images: [comperesImage], header: headers, parameters: [:],completion: self!.ProfileImageNetwork)
                }
            }
        }.disposed(by: self.disposeBag)
        
    }
    
    func selectImageTappedForLicesne() {
        
        uploadFilesButton.rx.tap.subscribe { [weak self] _ in
          
            ImagePickerManager().pickImage(self!){[weak self] image in
  
                self?.uploadImageForLicense(image: image)
            }
        }.disposed(by: self.disposeBag)
        
    }
    
    func uploadImageForLicense(image: UIImage) {
        let compresedImage = UploadDataa(data: image.jpegData(compressionQuality: 0.1)!, Key: "personal_image")
        AlamofireMultiPart.shared.PostMultiWithModel(model: SuccessModelImage.self, url: uploadImageApi, Images: [compresedImage], header: headers, parameters: [:],completion: self.ProfileImageNetworkForLicense)
    }
    
    func appedFilesToArr() {
        guard let files = try? articleDetailsViewModel.Files.value() else { return }
        for item in files {
            self.files.append(item.filePath ?? "")
        }
    }
    
    func saveUpdatedBasicData() {
        
        savebutton.rx.tap.subscribe { [weak self] _  in
            let respondTime = Int(self?.respondTimeField.text ?? "")
            self?.appedFilesToArr()
            let basicData = BasicData(pharmacyNameEn: self?.pharmacyNameEn.text ?? "", pharmacyNameAr: self?.pharmcyNameAr.text ?? "", pharmacyAboutEn: self?.aboutPharmacyEn.text ?? "", pharmacyAboutAr: self?.aboutPharmacyAr.text ?? "", image: self?.BasicDataResponse?.image ?? "", TimeToRespondTheOrderInHours: respondTime ?? 0, Files: self?.files ?? [])
            
            self?.articleDetailsViewModel.updateBasicData(BasicData: basicData, image: self?.profileImagePath ?? "")
            
        }.disposed(by: self.disposeBag)

    }
}
extension BasicDataViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}

extension BasicDataViewController {
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

    
    func ProfileImageNetworkForLicense(result : ServerResponse<SuccessModelImage>){
        switch result {
        case .success(let model):
            if model.successtate == 200 {
                let imageAsFile = File(filePath: model.message ?? "")
                self.licenseImage = try! self.articleDetailsViewModel.Files.value()
                self.licenseImage.append(imageAsFile)
                self.articleDetailsViewModel.Files.onNext(self.licenseImage)
                self.filesCollectionView.reloadData()
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
