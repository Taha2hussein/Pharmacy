//
//  EditProfileRouter.swift
//  Pharmacy
//
//  Created by A on 31/01/2022.
//

import Foundation
import UIKit

class EditProfileRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    private var source: ProfileModel?

    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.editProfile.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.editProfile.rawValue)as? EditProfileViewController
        
        viewController!.articleDetailsViewModel.ProfileModel = source

        return viewController!
    }
    
    init() {
        
    }
    
    init<T>(source: T?) {
        self.source = source as? ProfileModel
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }

    func backView() {
        self.sourceView?.navigationController?.popViewController(animated: true)
    }
}
