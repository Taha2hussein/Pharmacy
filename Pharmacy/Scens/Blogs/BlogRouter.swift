//
//  BlogRouter.swift
//  Pharmacy
//
//  Created by A on 03/02/2022.
//

import Foundation
import UIKit

class BlogRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.blog.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.blogViewController.rawValue)
        
        return viewController
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func showBlogDetails(blogDrtails: Int) {
        let source = BlogDetailsRouter(source: blogDrtails).viewController
        self.sourceView?.navigationController?.pushViewController(source, animated: true)
    }
}
