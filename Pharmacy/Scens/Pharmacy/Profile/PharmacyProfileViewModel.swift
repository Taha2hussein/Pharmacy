//
//  PharmacyProfileViewModel.swift
//  Pharmacy
//
//  Created by A on 08/02/2022.
//

import UIKit
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
    var activatonInstance: ActivePharmacyBranch?
    var deleteBranch: DeleteBranchModel?
    var activatePharmacist: ActivatePharmacistModel?
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
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
        state.isLoading.accept(true)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                var pharmcy : PharmacyProfileModel?
                pharmcy = try decoder.decode(PharmacyProfileModel.self, from: data)
                print(pharmcy,"pharmcyData")
                if pharmcy?.successtate == 200 {
                    self.pharmacyObject.onNext(pharmcy!)
                    self.brnachesProfile.onNext(pharmcy?.message?.branchesList ?? [])
                    self.brahcnhPharmacist.onNext(pharmcy?.message?.employeesList ?? [])
                }
                
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: pharmcy?.errormessage ?? "An error occured , Please try again".localized, viewController: self.view!)
                        
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
    
    func seAllReviews(review:[ReviewsDetail]) {
        router?.seeAllReviews(review: review)
    }
}

extension PharmacyProfileViewModel {
    
    
    func deleteBranchs(branchId:Int) {
        
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: deleteBranchApi + "ID=\(branchId)")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                self.deleteBranch = try decoder.decode(DeleteBranchModel.self, from: data)
                if self.deleteBranch?.successtate == 200 {
                    DispatchQueue.main.async {
                        //                        self.getPharmacyProfile()
                        Alert().displayError(text: self.deleteBranch?.message ?? "An error occured , please try again".localized, viewController: self.view!)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: self.deleteBranch?.errormessage ?? "An error occured , please try again".localized, viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
            deactivateBranc.onNext(false)
        }.resume()
        
    }
    
    func activeBranch(branchId:Int, activation: Bool) {
        
        
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: activeBranchApi + "ID=\(branchId)&&Status=\(activation)")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                self.activatonInstance = try decoder.decode(ActivePharmacyBranch.self, from: data)
                if self.activatonInstance?.successtate == 200 {
                    DispatchQueue.main.async {
                        self.getPharmacyProfile()
                        
                    }
                }
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: self.activatonInstance?.errormessage ?? "An error occured , please try again".localized, viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
            deletBranchCheck.onNext(false)
        }.resume()
    }
}

extension PharmacyProfileViewModel {
    
    func embedUperView(uperView: UIView) {
        router?.embedUperView(uperView: uperView)
    }
}


extension PharmacyProfileViewModel {
    func activePharmacist(id:Int, activation: Bool) {
        
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: activePharmacistApi + "ID=\(id)&&Status=\(activation)")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                self.activatePharmacist = try decoder.decode(ActivatePharmacistModel.self, from: data)
                if self.activatePharmacist?.successtate == 200 {
                    DispatchQueue.main.async {
                        self.getPharmacyProfile()
                        
                    }
                }
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: self.activatePharmacist?.errormessage ?? "An error occured , please try again".localized, viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
