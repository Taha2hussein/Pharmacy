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
    private var addOrEdit = Bool()
    private var headerLabel = String()
    private var id = Int()
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.AddPharmacy.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.AddPharmacyView.rawValue)as! AddPharmacyViewController
        viewController.articleDetailsViewModel.addOrEdit = self.addOrEdit
        viewController.articleDetailsViewModel.headerLabel = self.headerLabel
        viewController.articleDetailsViewModel.id = self.id
        return viewController
    }
    
    init() {
        
    }
    
    init(addOrEdit:Bool ,headerLabel: String,id:Int ){
        self.addOrEdit = addOrEdit
        self.headerLabel = headerLabel
        self.id = id
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    func showMapview(){
        let mapView = MapRouter().viewController
        sourceView?.navigationController?.pushViewController(mapView, animated: true)
    }
    
    func backView(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
//    func navigateToMainview() {
//        let tabBarView = UIStoryboard.init(name: Storyboards.tabBar.rawValue, bundle: nil)
//        let tabBar = tabBarView.instantiateViewController(withIdentifier: ViewController.tabBarView.rawValue)
//        sourceView?.navigationController?.pushViewController(tabBar, animated: true)
//    }
}
