//
//  ChangePasswordRouter.swift
//  Pharmacy
//
//  Created by taha hussein on 16/04/2022.
//

import Foundation
import UIKit

class ChangePasswordRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.ChangePassword.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.ChangePasswordViewController.rawValue)
        
        return viewController
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
   
    func navigateToDetailsView() {
        self.sourceView?.navigationController?.popViewController(animated: true)
    }
    
    func backView(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
}
