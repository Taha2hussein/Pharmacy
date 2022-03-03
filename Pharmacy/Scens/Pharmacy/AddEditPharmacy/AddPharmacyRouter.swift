//
//  AddPharmacyRouter.swift
//  Pharmacy
//
//  Created by taha hussein on 03/03/2022.
//

import Foundation

import UIKit

class AddPharmacyRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.AddPharmacy.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.AddPharmacyView.rawValue)
        
        return viewController
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    func showMapview(){
        let mapView = MapRouter().viewController
        sourceView?.navigationController?.pushViewController(mapView, animated: true)
    }
//    func navigateToMainview() {
//        let tabBarView = UIStoryboard.init(name: Storyboards.tabBar.rawValue, bundle: nil)
//        let tabBar = tabBarView.instantiateViewController(withIdentifier: ViewController.tabBarView.rawValue)
//        sourceView?.navigationController?.pushViewController(tabBar, animated: true)
//    }
}
