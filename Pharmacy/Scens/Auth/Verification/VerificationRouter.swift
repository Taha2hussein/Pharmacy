//
//  VerificationRouter.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import Foundation
import UIKit

class VerificationRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.verification.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.verification.rawValue)
        
        return viewController
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func showVerificationMobile() {
        let verificationMobile = ConfirmMobileRouter().viewController
        self.sourceView?.navigationController?.pushViewController(verificationMobile, animated: true)
    }
}
