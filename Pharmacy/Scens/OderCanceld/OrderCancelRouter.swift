//
//  OrderCancelRouter.swift
//  Pharmacy
//
//  Created by taha hussein on 08/03/2022.
//


import Foundation
import UIKit

class OrderCancelRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    private var orderId = Int()
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.orders.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.orderedCanceled.rawValue)as? OrderCancelViewController
        viewController?.articleDetailsViewModel.orderId = orderId
        return viewController!
    }
    
    init() {
        
    }
    
    init(orderId: Int) {
        self.orderId = orderId
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
 
    func backAction() {
        self.sourceView?.navigationController?.popViewController(animated: true)
    }
}
