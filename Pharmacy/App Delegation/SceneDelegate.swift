//
//  SceneDelegate.swift
//  Pharmacy
//
//  Created by A on 07/01/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
//            let logedBefore =  LocalStorage().getLogedBefore()
//            
//            if logedBefore {
//                let tabBarView = UIStoryboard.init(name: "Main", bundle: nil)
//                let tabBar = tabBarView.instantiateViewController(withIdentifier: "TabBarViewController")as? TabBarViewController
//                window.rootViewController = UINavigationController(rootViewController: tabBar!)
//            }
//            else {
//                window.rootViewController = UINavigationController(rootViewController: LoginRouter().viewController)
//            }
//            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
