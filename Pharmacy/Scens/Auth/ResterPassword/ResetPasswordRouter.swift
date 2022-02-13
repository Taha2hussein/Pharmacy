//
//  ResetPasswordRouter.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//


import Foundation
import UIKit

class ResetPasswordRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.resetPassword.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.resetPassword.rawValue)
        
        return viewController
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func showLoginView() {
        let loginView = UIStoryboard.init(name: Storyboards.main.rawValue, bundle: nil)
        let login = loginView.instantiateViewController(withIdentifier: ViewController.loginView.rawValue)
        UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: login)
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

}
