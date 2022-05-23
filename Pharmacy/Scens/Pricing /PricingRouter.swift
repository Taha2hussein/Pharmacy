//
//  PricingRouter.swift
//  Pharmacy
//
//  Created by taha hussein on 12/03/2022.
//

import Foundation
import UIKit

class PricingRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    private var OrderTrackingMessage: OrderTrackingMessage?
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.Pricing.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.PricingViewController.rawValue)as?   PricingViewController

        viewController?.articleDetailsViewModel.OrderTrackingMessage = OrderTrackingMessage
        return viewController!
    }
    
    init() {
        
    }
    
    init(OrderTrackingMessage: OrderTrackingMessage) {
        self.OrderTrackingMessage = OrderTrackingMessage
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func addNewMedicingView(orderType: orderTypeSelected,MedicinCategoryId: Int , MedicineType: Int) {
      
        let addNewMedicingView = FindAlternativeRouter(orderType: orderType, MedicinCategoryId: MedicinCategoryId, MedicineType: MedicineType).viewController
        self.sourceView?.navigationController?.pushViewController(addNewMedicingView, animated: true)
    }
 
    func backAction() {
        self.sourceView?.navigationController?.popViewController(animated: true)
    }
}
