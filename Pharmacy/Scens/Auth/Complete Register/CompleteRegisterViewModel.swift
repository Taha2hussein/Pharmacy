//
//  CompleteRegisterViewModel.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import WPMediaPicker

typealias Parameters = [String: String]

class CompleteRegisterViewModel {
    
    private weak var view: CompleteRegisterViewController?
    private var router: CompleteRegisterRouter?
    let selectedImages =  PublishSubject<[ZTAssetWrapper?]>()
    let selectedImagePharmacy = PublishSubject<ZTAssetWrapper>()
    private let disposeBag = DisposeBag()
    var state = State()
    var registerParamerters : RegisterParameters!
    var countrySubject =  PublishSubject<[CountryMessage]>()
    var completeRegisterInstance = RegisterModel()
    var countrySubjectObservable: Observable<[CountryMessage]> {
        return countrySubject
    }
    
    var citySubject =  PublishSubject<[CountryMessage]>()
    var citySubjectObservable: Observable<[CountryMessage]> {
        return citySubject
    }
    
    var areaSubject =  PublishSubject<[CountryMessage]>()
    var areaSubjectObservable: Observable<[CountryMessage]> {
        return areaSubject
    }
    
    func bind(view: CompleteRegisterViewController, router: CompleteRegisterRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
}

extension CompleteRegisterViewModel: pushView {
    func pushNextView() {
        self.router?.showMapview()
    }
}

extension CompleteRegisterViewModel: getAllCountries{
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

extension CompleteRegisterViewModel {
    func register(){
        
        let parameter = ["OwnerFirstName": self.registerParamerters.firstName,
                         "OwnerLastName": self.registerParamerters.lastName,
                         "MobileCode": "02",
                         "Mobile": self.registerParamerters.phoneNumber,
                         "Email": self.registerParamerters.email,
                         "Password": self.registerParamerters.password,
                         "PharmacyNameAr": self.registerParamerters.pharmacyName,
                         "PharmacyNameEn": self.registerParamerters.pharmacyName,
                         "BranchName": self.registerParamerters.branch,
                         "PharmacyImage": self.registerParamerters.pharmacyImage,
                         "OwnerImage": self.registerParamerters.pharmacyImage,
                         "Address": self.registerParamerters.adress,
                         "HasDelivery": self.registerParamerters.hasDelivery,
                         "DeliveryFees": 10,
                         "Lang": self.registerParamerters.locationLongitude,
                         "Lat": self.registerParamerters.locationLatitude,
                         "Countryfk": self.registerParamerters.country,
                         "CityFk": self.registerParamerters.city,
                         "AreaFk": self.registerParamerters.area,
                         "License": self.registerParamerters.licens
        ] as [String : Any]
        print(parameter)
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string:registerApi)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let jsonData = try? JSONSerialization.data(withJSONObject: parameter, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        request.httpBody = jsonString?.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                self.completeRegisterInstance = try decoder.decode(RegisterModel.self, from: data)
                print( self.completeRegisterInstance)
                if  self.completeRegisterInstance.successtate == 200 {
                    DispatchQueue.main.async {
                        defer{
                            self.router?.showVerificationCode()
                        }
                        LocalStorage().saveTokenCode(using:  self.completeRegisterInstance.message?.tokenCode ?? "")
                        
                        LocalStorage().saveActiveLink(using: self.completeRegisterInstance.message?.activateLink ?? "")
                    }
                }
                
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
