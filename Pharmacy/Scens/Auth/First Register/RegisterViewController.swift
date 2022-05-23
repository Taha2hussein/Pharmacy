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

class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var ownerImageButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var phoneCode: UITextField!
    @IBOutlet weak var ownerEmail: UITextField!
    @IBOutlet weak var ownertLastName: UITextField!
    @IBOutlet weak var ownertFirstName: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var flagImage: UIImageView!

    var articleDetailsViewModel = FirstRegisterViewModel()
    private var router = FirstRegisterRouter()
//    private var Images = [ZTAssetWrapper]()
    private var selectedImageCheckOnce = true
    private var profileImagePath: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        subscribeToContinueRegister()
        selectImageTappedForOwner()
        bindFirstName()
        bindLastName()
        bindImageToOwnerImage()
        bindEmail()
        bindMobile()
        bindPassword()
        addTooglePasswordShowButton()
        backAction()
//        validateData()
        subscribeToLoader()
        setUpPhone()
    }
    
    func setUpPhone() {
        ImageCountryCode().setCountryCode(countryImage: flagImage)
        
    }
    
    func addTooglePasswordShowButton() {
        confirmPassword.enablePasswordToggle(textField: confirmPassword)
        passwordTextField.enablePasswordToggle(textField: passwordTextField)

    }
    
   
    
    func backAction() {
        backButton.rx.tap.subscribe { [weak self] _ in
            self?.router.backView()
        } .disposed(by: self.disposeBag)

    }
    
    func validateData() {
        articleDetailsViewModel.isValid.subscribe(onNext: {[weak self] (isEnabled) in
            isEnabled ? (self?.nextButton.isEnabled = true) : (self?.nextButton.isEnabled = false)
        }).disposed(by: self.disposeBag)
        
    }

    func useWPmediaPicker() {

        ImagePickerManager().pickImage(self){ image in
            self.articleDetailsViewModel.selectedImageOwner.onNext(image)
           }
    }
    
    
    func subscribeToLoader() {
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
    
    func bindImageToOwnerImage() {
        articleDetailsViewModel.selectedImageOwner.subscribe {[weak self] image in
            if let image = image.element {
                DispatchQueue.main.async {
                self?.ownerImageButton.setImage(image, for: .normal)
                    singlton.shared.userImage.append(UploadDataa(data: image.jpegData(compressionQuality: 0.1)!, Key: "personal_image"))
                    AlamofireMultiPart.shared.PostMultiWithModel(model: SuccessModelImage.self, url: uploadImageApi, Images: singlton.shared.userImage, header: headers, parameters: [:],completion: self!.ProfileImageNetwork)
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
        self.router.navigateToCompleteRegisterView(imagePath: self.profileImagePath)
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
    
    func showAlert(message:String) {
        Alert().displayError(text: message, viewController: self)
    }
    
    func validateALLField() {
        if ownertFirstName.text!.isEmpty || ownertLastName.text!.isEmpty || ownerEmail.text!.isEmpty || phoneTextField.text!.isEmpty || passwordTextField.text!.isEmpty || confirmPassword.text!.isEmpty{
            showAlert(message: LocalizedStrings().emptyField)
        }
        
        else if ownertFirstName.text!.count < 3 ||  ownertFirstName.text!.count > 75 || ownertLastName.text!.count < 3 ||  ownertLastName.text!.count > 75 {
            showAlert(message: LocalizedStrings().validateUserName)
        }
        
        
        else if passwordTextField.text!.count < 8 || confirmPassword.text!.count < 8 {
            showAlert(message: LocalizedStrings().passwordCount)
        }
        
        else if isEmailValid(ownerEmail.text!) == false {
            showAlert(message: LocalizedStrings().unvalidemail)
        }
      
        else if passwordTextField.text! != confirmPassword.text! {
            showAlert(message: LocalizedStrings().passwordMatch)
        }
        
        else if phoneTextField.text!.count < 11 {
            showAlert(message: LocalizedStrings().validPhoneNumber)
        }
        else if profileImagePath == ""{
            showAlert(message: LocalizedStrings().uploadImage)
        }
        else {
            self.pushCompleteRegisterView()
        }
        
    }
    
    func subscribeToContinueRegister() {
        nextButton.rx.tap.subscribe { [weak self] _ in
            self?.validateALLField()
//            self?.pushCompleteRegisterView()
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

extension RegisterViewController {
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
