//
//  DashboardRouter.swift
//  Pharmacy
//
//  Created by A on 20/01/2022.
//


import Foundation
import UIKit

class DashboardRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.main.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.DashBoard.rawValue)
        
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
