//
//  RegisterViewController.swift
//  Pharmacy
//
//  Created by A on 07/01/2022.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import DropDown
import WPMediaPicker

class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var ownerImageButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var phoneCode: UITextField!
    @IBOutlet weak var ownerEmail: UITextField!
    @IBOutlet weak var ownertLastName: UITextField!
    @IBOutlet weak var ownertFirstName: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var articleDetailsViewModel = FirstRegisterViewModel()
    private var router = FirstRegisterRouter()
    private var Images = [ZTAssetWrapper]()
    private var selectedImageCheckOnce = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        subscribeToContinueRegister()
//        selectImageTappedForOwner()
        bindFirstName()
        bindLastName()
        bindImageToOwnerImage()
        bindEmail()
        bindMobile()
        bindPassword()
        validateData()
    }
    
    func validateData() {
        articleDetailsViewModel.isValid.subscribe(onNext: {[weak self] (isEnabled) in
            isEnabled ? (self?.nextButton.isEnabled = true) : (self?.nextButton.isEnabled = false)
        }).disposed(by: self.disposeBag)
        
    }
    
    func useWPmediaPicker() {
        let options =  WPMediaPickerOptions()
        options.filter = .image
        options.allowMultipleSelection = true
        options.showMostRecentFirst = true
        options.allowCaptureOfMedia = false
        let picker = WPNavigationMediaPickerViewController(options: options)
        picker.modalPresentationStyle = .fullScreen
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    func bindImageToOwnerImage() {
        articleDetailsViewModel.selectedImageOwner.subscribe {[weak self] image in
            if let image = image.element {
                DispatchQueue.main.async {
                self?.ownerImageButton.setImage(image.image, for: .normal)
                LocalStorage().saveOwnerImage(using: image.image ?? UIImage(named:"Avatar")!)
                }
            }
        }.disposed(by: self.disposeBag)
        
    }
    
    func pushCompleteRegisterView() {
        defer{
            pushView()
        }
        assignValueToLocal()
    }
    
    func pushView() {
        articleDetailsViewModel.pushNextView()
    }
    
    func assignValueToLocal() {
        articleDetailsViewModel.assignDataToSingelton()
    }
    
    func selectImageTappedForOwner() {
        
        ownerImageButton.rx.tap.subscribe { [weak self] _ in
            self?.useWPmediaPicker()
        }.disposed(by: self.disposeBag)
        
    }
}

extension RegisterViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}

extension RegisterViewController {
    func subscribeToContinueRegister() {
        nextButton.rx.tap.subscribe { [weak self] _ in
            self?.pushCompleteRegisterView()
        } .disposed(by: self.disposeBag)
    }
}

extension RegisterViewController {
    
    func bindFirstName() {
        ownertFirstName.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.firstName).disposed(by: self.disposeBag)
    }
    
    func bindLastName() {
        ownertLastName.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.lastName).disposed(by: self.disposeBag)
    }
    
    func bindEmail() {
        ownerEmail.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.email).disposed(by: self.disposeBag)
    }
    
    func bindMobile() {
        phoneTextField.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.phone).disposed(by: self.disposeBag)
    }
    
    func bindPassword() {
        passwordTextField.rx.text
            .orEmpty
            .bind(to: articleDetailsViewModel.password).disposed(by: self.disposeBag)
    }
}

extension RegisterViewController: WPMediaPickerViewControllerDelegate {
    private func mediaPickerController(_ picker: WPMediaPickerViewController?, previewViewControllerForAssets assets: [WPMediaAsset?]?, selectedIndex selected: Int) {
        
    }
    
    func mediaPickerController(_ picker: WPMediaPickerViewController, didFinishPicking assets: [WPMediaAsset]) {
        picker.dismiss(animated: true, completion: nil)
        
        for (_ , element ) in assets.enumerated() {
            
            if element.assetType() == .image  {
                element.image(with: CGSize(width: 100, height: 100), completionHandler: { image, err in
                    
                    let selectedImage = ZTAssetWrapper(url: nil, type: .image, avAssetUrl: nil, image: image)
                    if self.selectedImageCheckOnce {
                        self.articleDetailsViewModel.selectedImageOwner.onNext(selectedImage)
                        self.selectedImageCheckOnce = false
                    }
                   }
                )
            }
        }
    }
}
