//
//  FindAlternativeRouter.swift
//  Pharmacy
//
//  Created by taha hussein on 13/03/2022.
//

import Foundation
import UIKit

class FindAlternativeRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    private var orderType: orderTypeSelected?,MedicinCategoryId: Int? , MedicineType: Int?
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.Pricing.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.FindAlternativeViewController.rawValue)as?   FindAlternativeViewController

        viewController?.articleDetailsViewModel.orderType = self.orderType
        viewController?.articleDetailsViewModel.MedicinCategoryId = self.MedicinCategoryId
        viewController?.articleDetailsViewModel.MedicineType = self.MedicineType
     print("zzzz" , self.MedicineType , self.MedicinCategoryId)
        return viewController!
    }
    
    init() {
        
    }
    
    init(orderType: orderTypeSelected,MedicinCategoryId: Int , MedicineType: Int) {
        self.orderType = orderType
        self.MedicinCategoryId = MedicinCategoryId
        self.MedicineType = MedicineType
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
//    
    func showFilterView(MedicinCategoryId: Int) {
        let filterview = MedicineFilterRouter(MedicinCategoryId: MedicinCategoryId).viewController
        self.sourceView?.navigationController?.pushViewController(filterview, animated: true)
    }
// 
    func backAction() {
        self.sourceView?.navigationController?.popViewController(animated: true)
    }
}
