//
//  EditProfileViewModel.swift
//  Pharmacy
//
//  Created by A on 30/01/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import SwiftUI

class EditProfileViewModel{
    
    private weak var view: EditProfileViewController?
    private var router: EditProfileRouter?
    var state = State()
    var ProfileObject =  PublishSubject<ProfileModel>()
    var ProfileBranch = PublishSubject<[PfofileBranch]>()
    
    func bind(view: EditProfileViewController, router: EditProfileRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func getPhofile() {
        
        let  PharmacyProviderEmployeeID = LocalStorage().getPharmacyProviderFk()
        var request = URLRequest(url: URL(string: profileApi + "\(PharmacyProviderEmployeeID)")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        state.isLoading.accept(true)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                var profile = ProfileModel()
                profile = try decoder.decode(ProfileModel.self, from: data)
                print(profile , "profile")
                if profile.successtate == 200 {
                    
                    self.ProfileObject.onNext(profile)
                    self.ProfileBranch.onNext(profile.message?.branches ?? [])
                }
                
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}

extension EditProfileViewModel: backView {
    func backNavigationview() {
        router?.back()
    }
    
    
}
