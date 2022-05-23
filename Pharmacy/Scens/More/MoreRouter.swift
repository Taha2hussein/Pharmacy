//
//  MoreRouter.swift
//  Pharmacy
//
//  Created by A on 30/01/2022.
//

import Foundation
import UIKit

class MoreRouter {
    var viewController: UIViewController {
        return createViewController()
    }
    
    private var sourceView: UIViewController?
    
    private func createViewController() -> UIViewController {
      
        let view = UIStoryboard.init(name: Storyboards.tabBar.rawValue, bundle: nil)
        
        let viewController = view.instantiateViewController(withIdentifier: ViewController.moreviewController.rawValue)
        
        return viewController
    }
    
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }

    func embedUperView(uperView: UIView) {
        let vc = UperRouter().viewController
        self.sourceView?.embed(vc, inParent: self.sourceView!, inView: uperView)
    }
    
    func showProfile() {
        let profile = ProfileRouter().viewController
        self.sourceView?.navigationController?.pushViewController(profile, animated: true)
    }
    
    func showBlogs() {
        let blogView = BlogRouter().viewController
        self.sourceView?.navigationController?.pushViewController(blogView, animated: true)
    }
    
    func showChangePassword() {

        let changePassword = ChangePasswordRouter().viewController
        self.sourceView?.navigationController?.pushViewController(changePassword, animated: true)
    }
    
    func rootToLogin() {
        let loginView = UIStoryboard.init(name: Storyboards.main.rawValue, bundle: nil)
        let login = loginView.instantiateViewController(withIdentifier: ViewController.loginView.rawValue)
        UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: login)
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
    
    func showTermsAndcondition() {
        let termsAndCondition = TermsAndConditionRouter().viewController
        self.sourceView?.navigationController?.pushViewController(termsAndCondition, animated: true)
    }
    
    func showProvacyPolicy() {
        let privacyPolicy = PrivacyPolicyRouter().viewController
        self.sourceView?.navigationController?.pushViewController(privacyPolicy, animated: true)
        
    }
    
    func showContactUs() {
        let contactUs = ContactUsRouter().viewController
        self.sourceView?.navigationController?.pushViewController(contactUs, animated: true)
    }
    
    func showFAQ() {
        let fAQ = FAQRouter().viewController
        self.sourceView?.navigationController?.pushViewController(fAQ, animated: true)
    }
}
