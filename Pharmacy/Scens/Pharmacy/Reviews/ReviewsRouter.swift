//
//  ReviewsRouter.swift
//  Pharmacy
//
//  Created by taha hussein on 03/03/2022.
//



import Foundation
import UIKit

class ReviewsRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    private var reviews = [ReviewsDetail]()
    private var sourceView: UIViewController?
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.pharmacyReviews.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.pharmacyReviews.rawValue)as? ReviewsViewController
//        viewController?.articleDetailsViewModel.allReviews = reviews
        return viewController!
    }
    
    init() {
        
    }
    
    init(source:  [ReviewsDetail]) {
        reviews = source
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    func backView(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
}
