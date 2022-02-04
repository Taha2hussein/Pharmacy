//
//  MoreViewController.swift
//  Pharmacy
//
//  Created by A on 30/01/2022.
//

import UIKit
import RxCocoa
import RxRelay
import RxSwift

class MoreViewController: BaseViewController {

    var articleDetailsViewModel = MoreViewModel()
    private var router = MoreRouter()
    
    @IBOutlet weak var blogView: UIView!
    @IBOutlet weak var myProfileView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var language: UIView!
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var changePasswordView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        articleDetailsViewModel.embedUperView(uperView: headerView)
        setGesturesForProfile()
        setGesturesForBlog()
        setGesturesForChangePassword()
        setGesturesForHelp()
        setGesturesForLanguage()
        setGesturesForLogout()
    }
   
    func setGesturesForProfile() {
        let myProfile = UITapGestureRecognizer(target: self, action: #selector(self.editProfile))
        myProfileView.isUserInteractionEnabled = true
        myProfileView.addGestureRecognizer(myProfile)
    }
    
    func setGesturesForBlog() {
        let blog = UITapGestureRecognizer(target: self, action: #selector(self.editBlog))
        blogView.isUserInteractionEnabled = true
        blogView.addGestureRecognizer(blog)
    }
    
    func setGesturesForChangePassword() {
        let changePassword = UITapGestureRecognizer(target: self, action: #selector(self.editChangePassword))
        changePasswordView.isUserInteractionEnabled = true
        changePasswordView.addGestureRecognizer(changePassword)
    }
    
    func setGesturesForHelp() {
        let help = UITapGestureRecognizer(target: self, action: #selector(self.editHelp))
        helpView.isUserInteractionEnabled = true
        helpView.addGestureRecognizer(help)
    }
    
    func setGesturesForLanguage() {
        let languages = UITapGestureRecognizer(target: self, action: #selector(self.editLanguage))
        language.isUserInteractionEnabled = true
        language.addGestureRecognizer(languages)
    }
    
    func setGesturesForLogout() {
        let logout = UITapGestureRecognizer(target: self, action: #selector(self.editLogout))
        logoutView.isUserInteractionEnabled = true
        logoutView.addGestureRecognizer(logout)
    }
}

extension MoreViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}

extension MoreViewController {
    
    @objc func editProfile() {
        articleDetailsViewModel.showProfile()
    }
    
    @objc func editBlog() {
        articleDetailsViewModel.showBlogs()
    }
    
    @objc func editChangePassword() {
        
    }
    
    @objc func editHelp() {
        
    }
    
    @objc func editLanguage() {
        
    }
    
    @objc func editLogout() {
        
    }
}
