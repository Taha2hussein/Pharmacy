//
//  EditProfileViewModel.swift
//  Pharmacy
//
//  Created by A on 31/01/2022.
//


import Foundation
import RxSwift
import RxCocoa
import RxRelay

class EditProfileViewModel {
    
    private weak var view: EditProfileViewController?
    private var router: EditProfileRouter?
    var ProfileModel: ProfileModel?
    private var branches = [Int]()
    var state = State()
    private var editOrofile : EditProfileModel?
    
    let isValid :  Observable<Bool>!
    var firstNameEN = BehaviorRelay<String>(value:"")
    var lastNameEN = BehaviorRelay<String>(value:"")
    var firstNameAR = BehaviorRelay<String>(value:"")
    var lastNameAR = BehaviorRelay<String>(value:"")
    var email = BehaviorRelay<String>(value:"")
    var phone = BehaviorRelay<String>(value:"")
    var gender = BehaviorRelay<String>(value:"")
    var date_Birth = BehaviorRelay<String>(value:"")
    
    func bind(view: EditProfileViewController, router: EditProfileRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
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
    
    func editProfile(gender: Int) {
        let PharmacyProviderFk = LocalStorage().getPharmacyProviderFk()
        let getPharmacsitID = LocalStorage().getPharmacsitID()
        
        let parameters = ["PharmacyProviderEmployeeID":getPharmacsitID,
                          "PharmacyProviderFk":PharmacyProviderFk,
                          "Type":1,
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
        var request = URLRequest(url: URL(string:editProfileApi)!)
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
                self.editOrofile = try decoder.decode(EditProfileModel.self, from: data)
                if self.editOrofile?.successtate == 200 {
                    DispatchQueue.main.async {
                        print("savedd" ,self.editOrofile )
                        self.backNavigationview()
                    }
                }
                else {
                    DispatchQueue.main.async {
                    Alert().displayError(text: self.editOrofile?.errormessage ?? "An error occured , please try again", viewController: self.view!)
                    }
                }
                
            } catch let err {
                print("Err", err)
            }
        }.resume()
        
    }
    
    func setup() {
        let branches = self.ProfileModel?.message?.branches
        for item in 0 ..< (branches?.count ?? 0) {
            self.branches.append(branches?[item].branchID ?? 0)
        }
    }
    
}

extension EditProfileViewModel: backView {
    func backNavigationview() {
        router?.backView()
    }
}
