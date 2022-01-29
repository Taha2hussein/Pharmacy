//
//  LoginRouter.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import Foundation
import UIKit

class LoginRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.main.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.loginView.rawValue)
        
        return viewController
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    func createAccount() {
        let createAccount = UIStoryboard.init(name: "Register", bundle: nil).instantiateViewController(withIdentifier: "PageViewController")
        sourceView?.navigationController?.pushViewController(createAccount, animated: true)
    }
    
    func navigateToDetailsView() {
        let tabBarView = UIStoryboard.init(name: Storyboards.tabBar.rawValue, bundle: nil)
        let tabBar = tabBarView.instantiateViewController(withIdentifier: ViewController.tabBarView.rawValue)
        sourceView?.navigationController?.pushViewController(tabBar, animated: true)
    }
}
