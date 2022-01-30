//
//  MoreRouter.swift
//  Pharmacy
//
//  Created by A on 30/01/2022.
//

import Foundation
import UIKit

class MoreRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.tabBar.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.moreviewController.rawValue)
        
        return viewController
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }

    func embedUperView(uperView: UIView) {
        let vc = UperRouter().viewController
        self.sourceView?.embed(vc, inParent: self.sourceView!, inView: uperView)
    }
    
    func showProfile() {
        let profile = EditProfileRouter().viewController
        self.sourceView?.navigationController?.pushViewController(profile, animated: true)
    }
}
