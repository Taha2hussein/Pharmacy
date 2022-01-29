//
//  WalletsDetailsRouter.swift
//  Pharmacy
//
//  Created by A on 23/01/2022.
//

import Foundation
import UIKit

class WalletsDetailsRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    private var source: BrahcnListMessage?
    private var Balance: WalletModel?
    private var previosView: previosView?
    
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.tabBar.rawValue, bundle: nil)
        let viewController = view.instantiateViewController(withIdentifier: ViewController.walletDetails.rawValue) as? WalletDetailsViewController
        viewController?.previosView = previosView
        viewController?.articleDetailsViewModel.articles = source
        viewController?.articleDetailsViewModel.Balance = Balance

        return viewController!
    }
    
    init() {
        
    }
    
    init<T>(source: T?, previosView: previosView) {
        self.source = source as? BrahcnListMessage
        self.previosView = previosView
    }
    
    init<T>(balance: T?, previosView: previosView) {
        print(balance)
        self.Balance = balance as? WalletModel
        self.previosView = previosView
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }

    func back() {
        self.sourceView?.navigationController?.popViewController(animated: true)
    }
}

enum previosView{
    case balance
    case pharmacy
}
