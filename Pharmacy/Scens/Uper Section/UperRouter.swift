//
//  UperRouter.swift
//  Pharmacy
//
//  Created by A on 26/01/2022.
//


import Foundation
import UIKit

class UperRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    private var headerTilte: String?
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.UperSection.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.UperSection.rawValue)as! UperViewController
        viewController.articleDetailsViewModel.headerTilte = self.headerTilte ?? "Home".localized
        return viewController
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    init() {
        
    }
    
    init(headerTilte:String) {
        self.headerTilte = headerTilte
    }
    
    func showNotificationList() {
        let NotificationListViewController = NotificationListRouter().viewController
        self.sourceView?.navigationController?.pushViewController(NotificationListViewController, animated: true)
    }
    
    func showTabBar() {
        let tabBarView = UIStoryboard.init(name: Storyboards.tabBar.rawValue, bundle: nil)
        let tabBar = tabBarView.instantiateViewController(withIdentifier: "TabBarViewController")as? TabBarViewController
        UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: tabBar!)
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
}
