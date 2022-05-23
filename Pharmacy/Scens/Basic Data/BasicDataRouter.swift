//
//  BasicDataRouter.swift
//  Pharmacy
//
//  Created by taha hussein on 23/04/2022.
//

import Foundation
import UIKit

class BasicDataRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.AddPharmacy.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.BasicDataViewController.rawValue)as?   BasicDataViewController

        return viewController!
    }
    
 
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func backAction() {
        self.sourceView?.navigationController?.popViewController(animated: true)
    }

}
