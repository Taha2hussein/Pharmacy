//
//  AddPharmacyViewModel.swift
//  Pharmacy
//
//  Created by taha hussein on 03/03/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
class AddPharmacyViewModel {
    
    private weak var view: AddPharmacyViewController?
    private var router: AddPharmacyRouter?
    private var SavePharmacyInstance: SavePharmacy?
    var countrySubject =  PublishSubject<[CountryMessage]>()

    var countrySubjectObservable: Observable<[CountryMessage]> {
        return countrySubject
    }
    
    var citySubject = PublishSubject<[CountryMessage]>()
    var citySubjectObservable: Observable<[CountryMessage]> {
        return citySubject
    }
    
    var areaSubject =  PublishSubject<[CountryMessage]>()
    var areaSubjectObservable: Observable<[CountryMessage]> {
        return areaSubject
    }
    
    var state = State()
    let isValid :  Observable<Bool>!
    
    var brnachNameEn = BehaviorRelay<String>(value:"")
    var brnachNameAr = BehaviorRelay<String>(value:"")
   
    var country = BehaviorRelay<String>(value:"")
    var city = BehaviorRelay<String>(value:"")
    var area = BehaviorRelay<String>(value:"")
    var mobile = BehaviorRelay<String>(value:"")
    var streetNameEn = BehaviorRelay<String>(value:"")
    var streetNameAr = BehaviorRelay<String>(value:"")
    
    var buildinghNameEn = BehaviorRelay<String>(value:"")
    var buildingNameAr = BehaviorRelay<String>(value:"")
    var landmarkeEn = BehaviorRelay<String>(value:"")
    var landmarkAr = BehaviorRelay<String>(value:"")
    var location = BehaviorRelay<String>(value:"")
    var howFarService = BehaviorRelay<String>(value:"")
    var fromDate = BehaviorRelay<String>(value:"")
    var endDate = BehaviorRelay<String>(value:"")

    init() {
        isValid = Observable.combineLatest(
            self.brnachNameEn.asObservable() ,self.brnachNameAr.asObservable() ,self.city.asObservable(),self.area.asObservable(),self.mobile.asObservable(),self.streetNameEn.asObservable() , self.streetNameAr.asObservable(),self.buildinghNameEn.asObservable())
        
        { (brnachNameEn , brnachNameAr ,city ,area,mobile,streetNameEn,streetNameAr,buildinghNameEn  ) in
            return brnachNameEn.count > 0
            && brnachNameAr.count > 0
            && city.count > 0
            && area.count > 0
            && mobile.count > 0
            && streetNameEn.count > 0
            && streetNameAr.count > 0
            && buildinghNameEn.count > 0
        
        }
    }
    
    func bind(view: AddPharmacyViewController, router: AddPharmacyRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}

extension AddPharmacyViewModel {
    func saveEditPharmacy(HasDelivery: Bool , TwintyFourHoursService: Bool , paymentType : Int , selectedCountry: Int ,selectedCity: Int ,selectedArea: Int  ){
        let storge = LocalStorage()
        state.isLoading.accept(true)
        let parameter = ["Address": storge.getLocationName(),
                         "AreaID": selectedArea,
                         "BranchLang": storge.getLocationLongituded(),
                         "MobileNumber": self.mobile.value,
                         "BranchLat": storge.getlocationLatitude(),
                         "BranchNameAr": self.brnachNameAr.value,
                         "BranchNameEn": self.brnachNameEn.value,
                         "CityID": selectedCity,
                         "CountryID": selectedCountry,
                         "HasDelivery": HasDelivery,
                         "LandMarkAr": self.landmarkAr.value,
                         "LandMarkEn": self.landmarkeEn.value,
                         "MobileCode": "+2",
                         "PaymentType": paymentType,
                         "PharmacyProviderBranchId":storge.getPharmacyProviderFk(),
                         "PharmacyProviderFk":  storge.getPharmacyProviderFk(),
                         "ProvideServiceInKm": self.howFarService.value,
                         "TwintyFourHoursService": TwintyFourHoursService,
                         
        ] as [String : Any]
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string:addOrEditPharmacy)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let jsonData = try? JSONSerialization.data(withJSONObject: parameter, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        request.httpBody = jsonString?.data(using: .utf8)
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            self.state.isLoading.accept(false)
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                self.SavePharmacyInstance = try decoder.decode(SavePharmacy.self, from: data)
                if  self.SavePharmacyInstance?.successtate == 200 {
                    DispatchQueue.main.async {
                        self.router?.backView()
                    }
                }
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: self.SavePharmacyInstance?.errormessage ?? "An error occured , Please try again", viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
extension AddPharmacyViewModel: getAllCountries {
    func getAllCountry() {
        state.isLoading.accept(true)
        NetWorkManager.instance.API(method: .get, url: countrys) { [weak self](err, status, response:CountryLists?) in
            guard let self = self else { return }
            self.state.isLoading.accept(false)
            if let error = err {
                print(error.localizedDescription)
            }  else {
                guard let branchesModel = response else { return }
                if branchesModel.message?.count ?? 0 > 0 {
                    self.countrySubject.onNext(branchesModel.message ?? [])
                    self.citySubject.onNext(branchesModel.message ?? [])
                    self.areaSubject.onNext(branchesModel.message ?? [])
                    
                } else {
                }
            }
        }
    }
}
extension AddPharmacyViewModel: pushView {
    func pushNextView() {
        self.router?.showMapview()
    }
}
