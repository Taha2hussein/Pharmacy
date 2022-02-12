//
//  BlogDetailsRouter.swift
//  Pharmacy
//
//  Created by taha hussein on 12/02/2022.
//


import Foundation
import UIKit

class BlogDetailsRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    private var blogId : Int?
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.blog.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.blogDetails.rawValue)as? BlogDetailsViewController
        
        viewController?.articleDetailsViewModel.blogDetails = blogId

        return viewController!
    }
    
    init() {
        
    }
    
    init(source: Int?) {
        blogId = source
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func backView() {
        self.sourceView?.navigationController?.popViewController(animated: true)
    }
}
