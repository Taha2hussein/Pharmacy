//
//  ConfirmAccountRouter.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import UIKit

class ConfirmAccountRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.confirmaccount.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.confirmAccount.rawValue)
        
        return viewController
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToMainview() {
//        let tabBarView = UIStoryboard.init(name: Storyboards.tabBar.rawValue, bundle: nil)
//        let tabBar = tabBarView.instantiateViewController(withIdentifier: ViewController.tabBarView.rawValue)
        let loginView = LoginRouter().viewController
        sourceView?.navigationController?.pushViewController(loginView, animated: true)
    }
}
