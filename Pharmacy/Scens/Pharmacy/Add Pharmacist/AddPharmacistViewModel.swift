//
//  AddPharmacistViewModel.swift
//  Pharmacy
//
//  Created by taha hussein on 05/03/2022.
//

import Foundation
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
    
    func addPharmacistAction(gender: Int , branches: [Int],role:Int , image: String){
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
                          "DateOfBirth":date_Birth.value,
                          "Branches":branches
                         ] as [String : Any]
        print(parameters)
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: addPharmacistApi)!)
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
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
                    Alert().displayError(text: self.savePharmacistInstance?.errormessage ?? "An error occured , please try again", viewController: self.view!)
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
