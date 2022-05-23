//
//  MedicineFilterRouter.swift
//  Pharmacy
//
//  Created by taha hussein on 14/03/2022.
//


import Foundation
import UIKit

class MedicineFilterRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    private var MedicinCategoryId: Int?
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.Pricing.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.MedicineFilterViewController.rawValue)as?   MedicineFilterViewController
        viewController?.articleDetailsViewModel.MedicinCategoryId = MedicinCategoryId
        return viewController!
    }
    
    init() {
        
    }
    
    init(MedicinCategoryId: Int) {
        self.MedicinCategoryId = MedicinCategoryId
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }

//
    func backAction() {
//        selectedMedicineArr.removeAll()
        self.sourceView?.navigationController?.popViewController(animated: true)
    }
}
