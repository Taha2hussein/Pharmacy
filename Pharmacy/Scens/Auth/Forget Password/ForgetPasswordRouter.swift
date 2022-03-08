//
//  ForgetPasswordRouter.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import Foundation
import UIKit

class ForgetPasswordRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.forgetPassword.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.forgetPassword.rawValue)
        
        return viewController
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func showVerificationView() {
        let verificationView = VerificationRouter().viewController
        self.sourceView?.navigationController?.pushViewController(verificationView, animated: true)
    }
}
