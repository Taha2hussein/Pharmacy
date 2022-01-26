//
//  WalletsDetailsRouter.swift
//  Pharmacy
//
//  Created by A on 23/01/2022.
//

import Foundation
import UIKit

class WalletsDetailsRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    private var source: BrahcnListMessage?

    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.tabBar.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.walletDetails.rawValue) as? WalletDetailsViewController
        viewController?.articleDetailsViewModel.articles = source
        return viewController!
    }
    init() {
        
    }
    
    init<T>(source: T?) {
        self.source = source as? BrahcnListMessage
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }

}
