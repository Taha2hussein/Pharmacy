//
//  CompleteRegisterRouter.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import Foundation
import UIKit

class CompleteRegisterRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.register.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.CompleteRegister.rawValue)
        
        return viewController
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func showMapview(){
        let mapView = MapRouter().viewController
        sourceView?.navigationController?.pushViewController(mapView, animated: true)
    }
    
    func showVerificationCode() {
        let verificationCode = ConfirmAccountRouter().viewController
        sourceView?.navigationController?.pushViewController(verificationCode, animated: true)

    }
}
