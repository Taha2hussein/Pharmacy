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
    private var singleOrderStatus = Int()
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.orders.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.orderTracking.rawValue)as? OrderTrackingViewController
        viewController?.articleDetailsViewModel.orderId = orderId
        viewController?.articleDetailsViewModel.singleOrderStatus = singleOrderStatus
        return viewController!
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
 
    init() {
        
    }
    
    init(orderId: Int,singleOrderStatus:Int) {
        self.orderId = orderId
        self.singleOrderStatus = singleOrderStatus
    }
    
    func backAction() {
        toggleFinishOrderView.onNext(false)
        self.sourceView?.navigationController?.popViewController(animated: true)
    }
    
    func showPricingView(OrderTrackingModel:OrderTrackingMessage?){
        if let OrderTrackingModel = OrderTrackingModel {
            print(OrderTrackingModel, "OrderTrackingModel")
            let pricingView = PricingRouter(OrderTrackingMessage: OrderTrackingModel).viewController
        self.sourceView?.navigationController?.pushViewController(pricingView, animated: true)
        }
    }
}
