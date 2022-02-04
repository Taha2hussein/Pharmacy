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

class ProfileViewModel{
    
    private weak var view: ProfileViewController?
    private var router: ProfileRouter?
    var state = State()
    var ProfileObject =  PublishSubject<ProfileModel>()
    var ProfileBranch = PublishSubject<[PfofileBranch]>()
    
    func bind(view: ProfileViewController, router: ProfileRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func getPhofile() {
        
        let  PharmacyProviderEmployeeID = LocalStorage().getPharmacsitID()
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
                
                else {
                    Alert().displayError(text: profile.errormessage ?? "An error occured , Please try again", viewController: self.view!)
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}

extension ProfileViewModel: backView {
    func backNavigationview() {
        router?.back()
    }
    
    func goToEditProfile(ProfileModel: ProfileModel) {
        router?.goToEditProfile(ProfileModel:ProfileModel)
    }
}
