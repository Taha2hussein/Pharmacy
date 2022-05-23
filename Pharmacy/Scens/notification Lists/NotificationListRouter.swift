//
//  NotificationListRouter.swift
//  Pharmacy
//
//  Created by taha hussein on 19/05/2022.
//

import Foundation
import UIKit

class NotificationListRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.UperSection.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.NotificationListViewController.rawValue)

        return viewController
    }
    
 
    func backAtion() {
        self.sourceView?.navigationController?.popViewController(animated: true)
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func backAction() {
        self.sourceView?.navigationController?.popViewController(animated: true)
    }

}
