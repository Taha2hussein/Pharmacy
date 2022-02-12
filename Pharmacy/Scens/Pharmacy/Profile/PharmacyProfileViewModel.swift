//
//  PharmacyProfileViewModel.swift
//  Pharmacy
//
//  Created by A on 08/02/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class PharmacyProfileViewModel {
    
    private weak var view: PharmacyProfileViewController?
    private var router: PharmacyProfileRouter?
    var state = State()
    var brnachesProfile = PublishSubject<[BranchesList]>()
    var brahcnhPharmacist = PublishSubject<[EmployeesList]>()
    var pharmacyObject = PublishSubject<PharmacyProfileModel>()
    var segmentSelected = BehaviorRelay<segmet>(value: .brahnch)
    func bind(view: PharmacyProfileViewController, router: PharmacyProfileRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}

extension PharmacyProfileViewModel {
    func getPharmacyProfile() {
        let prharcyId = LocalStorage().getPharmacyProviderFk()
        var request = URLRequest(url: URL(string: pharmcyProfile + "?PharmacyID=\(prharcyId)")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        print(request)
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        state.isLoading.accept(true)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                var pharmcy : PharmacyProfileModel?
                pharmcy = try decoder.decode(PharmacyProfileModel.self, from: data)
                if pharmcy?.successtate == 200 {
                    self.pharmacyObject.onNext(pharmcy!)
                    self.brnachesProfile.onNext(pharmcy?.message.branchesList ?? [])
                    self.brahcnhPharmacist.onNext(pharmcy?.message.employeesList ?? [])
                }
                
                else {
                    DispatchQueue.main.async {
                    Alert().displayError(text: pharmcy?.errormessage ?? "An error occured , Please try again", viewController: self.view!)
    
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
