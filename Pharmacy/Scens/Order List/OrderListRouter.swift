//
//  OrderListRouter.swift
//  Pharmacy
//
//  Created by taha hussein on 08/03/2022.
//

import Foundation
import UIKit

class OrderListRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.tabBar.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.orderList.rawValue)
        
        return viewController
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
 
    func showOrderTracking(orderId: Int , singleOrderStatus:Int) {
        let canceledOrder = OrderTrackingRouter(orderId: orderId,singleOrderStatus:singleOrderStatus).viewController
        self.sourceView?.navigationController?.pushViewController(canceledOrder, animated: true)
    }
    
    func showCanceledOrder(orderId: Int) {
        let canceledOrder = OrderCancelRouter(orderId: orderId).viewController
        self.sourceView?.navigationController?.pushViewController(canceledOrder, animated: true)
    }
}
