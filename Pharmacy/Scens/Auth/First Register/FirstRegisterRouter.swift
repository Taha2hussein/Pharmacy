//
//  FirstRegisterRouter.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//


import Foundation
import UIKit

class FirstRegisterRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.register.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.firstRegister.rawValue)
        
        return viewController
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToCompleteRegisterView() {
        let completeRegsiterView = CompleteRegisterRouter().viewController
        sourceView?.navigationController?.pushViewController(completeRegsiterView, animated: true)
    }
}
