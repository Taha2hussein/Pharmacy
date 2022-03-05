//
//  AddPharmacistRouter.swift
//  Pharmacy
//
//  Created by taha hussein on 05/03/2022.
//


import Foundation
import UIKit

class AddPharmacistRouter {
    
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.AddPharmacy.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.addPharmacist.rawValue)
        
        return viewController
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func backView() {
        self.sourceView?.navigationController?.popViewController(animated: true)
    }
}
