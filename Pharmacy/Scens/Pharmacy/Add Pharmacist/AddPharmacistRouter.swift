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
    private var addOrEdit = Bool()
    private var headerLabel = String()
    private var id = Int()
    private var sourceView: UIViewController?
    private func createViewController() -> UIViewController {
        
        let view = UIStoryboard.init(name: Storyboards.AddPharmacy.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.addPharmacist.rawValue) as! AddPharmacistViewController
        
        viewController.articleDetailsViewModel.addOrEdit = self.addOrEdit
        viewController.articleDetailsViewModel.headerLabel = self.headerLabel
        viewController.articleDetailsViewModel.id = self.id
        return viewController
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    init() {
        
    }
    
    init(addOrEdit:Bool ,headerLabel: String,id:Int ){
        self.addOrEdit = addOrEdit
        self.headerLabel = headerLabel
        self.id = id
    }
    
    func backView() {
        self.sourceView?.navigationController?.popViewController(animated: true)
    }
}
