//
//  MapRouter.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import Foundation
import UIKit

class MapRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.mapView.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.location.rawValue)
        
        return viewController
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func popView(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
//    func navigateToDetailsView<T>(source: T?) {
//        let detailsView = DetailsConfiguration(source: source).viewController
//        sourceView?.navigationController?.pushViewController(detailsView, animated: true)
//    }
}
