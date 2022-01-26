//
//  WalletsRouter.swift
//  Pharmacy
//
//  Created by A on 20/01/2022.
//

import UIKit

class WalletsRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?

    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.tabBar.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.myWallets.rawValue)
        
        return viewController
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToDetailsView<T>(source: T?) {
        let detailsView = WalletsDetailsRouter(source: source).viewController
        
        sourceView?.navigationController?.pushViewController(detailsView, animated: true)
    }
}
//BrahcnListMessage
