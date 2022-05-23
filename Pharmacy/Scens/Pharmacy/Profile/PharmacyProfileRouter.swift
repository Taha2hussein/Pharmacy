//
//  PharmacyProfileRouter.swift
//  Pharmacy
//
//  Created by A on 08/02/2022.
//


import Foundation
import UIKit

class PharmacyProfileRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    private func createViewController() -> UIViewController {
        
        let view = UIStoryboard.init(name: Storyboards.tabBar.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.pharmacyPtofileViewController.rawValue)
        
        return viewController
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    //    func navigateToDetailsView<T>(source: T?) {
    //        let detailsView = DetailsConfiguration(source: source).viewController
    //        sourceView?.navigationController?.pushViewController(detailsView, animated: true)
    //    }
    func seeAllReviews(review:[ReviewsDetail]) {
        let review = ReviewsRouter(source: review).viewController
        self.sourceView?.navigationController?.pushViewController(review, animated: true)
    }
    
    func addPharmacist(addOrEdit:Bool, headerLAbel:String,id:Int) {
        let addEditPharmacistiew = AddPharmacistRouter(addOrEdit: addOrEdit, headerLabel: headerLAbel,id:id).viewController
        self.sourceView?.navigationController?.pushViewController(addEditPharmacistiew, animated: true)
    }
    
    func navigateToADdEditPharmacy(addOrEdit:Bool, headerLAbel:String,id:Int) {
        let addEditPharmacyView = AddPharmacyRouter(addOrEdit: addOrEdit, headerLabel: headerLAbel, id: id).viewController
        self.sourceView?.navigationController?.pushViewController(addEditPharmacyView, animated: true)
    }
    
    func embedUperView(uperView: UIView) {
        let vc = UperRouter(headerTilte: "Pharmacy".localized).viewController
        self.sourceView?.embed(vc, inParent: self.sourceView!, inView: uperView)
    }
    
    func navigateToBasicData() {
        let basicData = BasicDataRouter().viewController
        self.sourceView?.navigationController?.pushViewController(basicData, animated: true)
    }
}
