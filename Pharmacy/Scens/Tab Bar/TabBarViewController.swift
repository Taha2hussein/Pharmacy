//
//  TabBarViewController.swift
//  Pharmacy
//
//  Created by A on 18/01/2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.backgroundColor = .white
        tabBar.items?[4].title = ("More").localized
        tabBar.items?[3].title = ("Club").localized
        tabBar.items?[2].title = ("Pharmacy").localized
        tabBar.items?[1].title = ("Order").localized
        tabBar.items?[0].title = ("Home").localized

    }
   
}
