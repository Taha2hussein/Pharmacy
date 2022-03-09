//
//  OrderTrackingRouter.swift
//  Pharmacy
//
//  Created by taha hussein on 09/03/2022.
//

import Foundation
import UIKit

class OrderTrackingRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    private var orderId = Int()

    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.orders.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.orderTracking.rawValue)as? OrderTrackingViewController
        viewController?.articleDetailsViewModel.orderId = orderId
        
        return viewController!
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
 
    init() {
        
    }
    
    init(orderId: Int) {
        self.orderId = orderId
    }
    
    func backAction() {
        self.sourceView?.navigationController?.popViewController(animated: true)
    }
    
}
