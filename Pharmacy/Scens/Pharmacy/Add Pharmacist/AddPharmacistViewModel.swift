//
//  AddPharmacistViewModel.swift
//  Pharmacy
//
//  Created by taha hussein on 05/03/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class AddPharmacistViewModel {
    
    private weak var view: AddPharmacistViewController?
    private var router: AddPharmacistRouter?
    private var savePharmacistInstance : SavePharmacist?
    var state = State()
    let isValid :  Observable<Bool>!
    var firstNameEN = BehaviorRelay<String>(value:"")
    var lastNameEN = BehaviorRelay<String>(value:"")
    var firstNameAR = BehaviorRelay<String>(value:"")
    var lastNameAR = BehaviorRelay<String>(value:"")
    var email = BehaviorRelay<String>(value:"")
    var phone = BehaviorRelay<String>(value:"")
    var gender = BehaviorRelay<String>(value:"")
    var date_Birth = BehaviorRelay<String>(value:"")
    let selectedImageOwner = PublishSubject<UIImage>()
    var EditPharmacistInstance = PublishSubject<EditPharmacistMessage>()
    var addOrEdit = Bool()
    var headerLabel = String()
    var id = Int()
    var AllBranchesInstance = PublishSubject<[AllBranchesBranch]>()
    init() {
        isValid = Observable.combineLatest(
            self.firstNameEN.asObservable(),
            self.lastNameEN.asObservable() ,
            self.firstNameAR.asObservable(),
            self.lastNameAR.asObservable() ,
            self.email.asObservable() ,
            self.phone.asObservable() ,
            self.gender.asObservable(),
            self.date_Birth.asObservable()
        )
        { (firstNameEN, lastNameEn , firstNameAR , lastNameAR , email , gender , phone , date_Birth) in
            return firstNameEN.count > 0
            && lastNameEn.count > 0
            && firstNameAR.count > 0
            && lastNameAR.count > 0
            && email.count > 0
            && phone.count > 0
            && gender.count > 0
            && date_Birth.count > 0
        }
        
    }
    
    func bind(view: AddPharmacistViewController, router: AddPharmacistRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func addPharmacistAction(gender: Int , branches: [Int],role:Int , image: String,dateBirth:String){
        let PharmacyProviderFk = LocalStorage().getPharmacyProviderFk()
        let getPharmacsitID = LocalStorage().getPharmacsitID()
        
        let parameters = ["PharmacyProviderEmployeeID":getPharmacsitID,
                          "PharmacyProviderFk":PharmacyProviderFk,
                          "Type":role,
                          "MobileNumber":phone.value,
                          "MobileCode":"+2",
                          "LastNameEn":lastNameEN.value,
                          "LastNameEAr":lastNameAR.value,
                          "Gender":gender,
                          "FirstNameEn":firstNameEN.value,
                          "FirstNameAr": firstNameAR.value,
                          "Email":email.value,
                          "DateOfBirth":dateBirth,
                          "Branches":branches,
                          "Image":image
                         ] as [String : Any]
        print(parameters,"parametersaDd")
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: addPharmacistApi)!)
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        request.httpBody = jsonString?.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                self.savePharmacistInstance = try decoder.decode(SavePharmacist.self, from: data)
                if self.savePharmacistInstance?.successtate == 200 {
                    DispatchQueue.main.async {
                        print("savedd" ,self.savePharmacistInstance )
                        self.backNavigationview()
                    }
                }
                else {
                    
                    DispatchQueue.main.async {
                        Alert().displayError(text: self.savePharmacistInstance?.errormessage ?? "An error occured , please try again".localized, viewController: self.view!)
                    }
                }
                
            } catch let err {
                print("Err", err)
            }
        }.resume()
        
    }
}

extension AddPharmacistViewModel: backView {
    func backNavigationview() {
        router?.backView()
    }
}

extension AddPharmacistViewModel {
    func getPharmacyBranches() {
      
        var request = URLRequest(url: URL(string: AllBranchesApi)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
        state.isLoading.accept(true)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                var AllBranches : AllBranchesModel?
                AllBranches = try decoder.decode(AllBranchesModel.self, from: data)
                if AllBranches?.successtate == 200 {
                    self.AllBranchesInstance.onNext(AllBranches?.message?.branches ?? [])
                    
                }
                
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: AllBranches?.errormessage ?? "An error occured , Please try again".localized, viewController: self.view!)
    
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}


extension AddPharmacistViewModel {
    func getPharmacistForEdit() {
      
        var request = URLRequest(url: URL(string: editPharmacistApi + "\(self.id)")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
        state.isLoading.accept(true)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                var EditPharmacist : EditPharmacistModel?
                EditPharmacist = try decoder.decode(EditPharmacistModel.self, from: data)
                if EditPharmacist?.successtate == 200 {
                    if let editPharmacist = EditPharmacist?.message {
                    self.EditPharmacistInstance.onNext(editPharmacist)
                    }
                }
                
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: EditPharmacist?.errormessage ?? "An error occured , Please try again".localized, viewController: self.view!)
    
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
