//
//  EditProfileRouter.swift
//  Pharmacy
//
//  Created by A on 30/01/2022.
//


import Foundation
import UIKit

class ProfileRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.Profile.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.Profile.rawValue)
        
        return viewController
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }

    func goToEditProfile(ProfileModel: ProfileModel) {
        let editProfile = EditProfileRouter(source: ProfileModel).viewController
        self.sourceView?.navigationController?.pushViewController(editProfile, animated: true)
    }
    
    func back() {
        self.sourceView?.navigationController?.popViewController(animated: true)
    }
}
