//
//  FAQRouter.swift
//  Pharmacy
//
//  Created by taha hussein on 05/05/2022.
//

import Foundation
import Foundation
import UIKit

class FAQRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.webPage.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.FAQViewController.rawValue)

        return viewController
    }
    
 
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func backAction() {
        self.sourceView?.navigationController?.popViewController(animated: true)
    }

}
