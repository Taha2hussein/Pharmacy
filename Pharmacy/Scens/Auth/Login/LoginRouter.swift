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
    
    func navigateToDetailsView() {
        let tabBarView = UIStoryboard.init(name: "Main", bundle: nil)
        let tabBar = tabBarView.instantiateViewController(withIdentifier: "TabBarViewController")as? TabBarViewController
        sourceView?.navigationController?.pushViewController(tabBar!, animated: true)
    }
}
