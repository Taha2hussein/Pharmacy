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
    
//    func navigateToDetailsView<T>(source: T?) {
//        let detailsView = DetailsConfiguration(source: source).viewController
//        sourceView?.navigationController?.pushViewController(detailsView, animated: true)
//    }
}
