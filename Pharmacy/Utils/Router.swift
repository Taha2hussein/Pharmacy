//
//  Router.swift
//  Pharmacy
//
//  Created by A on 09/01/2022.
//

import Foundation
import UIKit

protocol Router {
    var alert:UIViewController? {get set}
    
}
extension Router{
    
    func getWindow()->UIWindow{
        var window = UIApplication.shared.delegate?.window!
        if #available(iOS 13.0, *) {
            window = UIApplication.shared.windows.first
        }else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            window = appDelegate.window
        }
        guard let hardWindow = window else { return UIWindow() }
        return hardWindow
    }
    
    func openAsRootView(using view:UIViewController, withTransition:Bool = false){
        let window = getWindow()
        guard withTransition else {
            window.rootViewController = view
            window.makeKeyAndVisible()
            return
        }
        UIView.transition(with: window, duration: 1.0, options: .transitionFlipFromRight, animations: {
            window.rootViewController = view
            window.makeKeyAndVisible()
        }, completion: nil)
    }
    
    func openModally(controller:UIViewController, transition: UIModalTransitionStyle) {
        let window = getWindow()
        let presentingController = window.rootViewController!
        controller.modalTransitionStyle = transition
        controller.modalPresentationStyle = .fullScreen
        presentingController.present(controller, animated: true, completion: nil)
    }
    
    func closeModal() {
        let window = getWindow()
        let presentingController = window.rootViewController!
        presentingController.dismiss(animated: true, completion: nil)
    }
    
    
 
    func embedd(into controller:UIViewController, childController:UIViewController, containerView: UIView){
        controller.children.forEach{$0.removeFromParent()}
        containerView.subviews.forEach{$0.removeFromSuperview()}
        
        controller.addChild(childController)
        childController.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
        containerView.addSubview(childController.view)
        childController.didMove(toParent: controller)
//        childController.didMove(toParent: controller)
    }
    
    func goToMainScreen() {
        print("goToMainScreen commented Temprary at \(#file) , \n \(#function)")
//        _ = MainContainerViewRouter()
    }
    
}
