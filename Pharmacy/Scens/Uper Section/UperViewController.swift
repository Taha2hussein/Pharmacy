//
//  UperViewController.swift
//  Pharmacy
//
//  Created by A on 26/01/2022.
//

import UIKit
import RxCocoa
import RxRelay
import RxSwift

class UperViewController: BaseViewController {
    
    @IBOutlet weak var homebutton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var notificationButton: SYBadgeButton!
    
    var articleDetailsViewModel = UperViewModel()
    private var router = UperRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        showHomeView()
        notificationButtonTapped()
        subsribeToNotificationCount()
        headerLabel.text  = articleDetailsViewModel.headerTilte
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        articleDetailsViewModel.getNotificationCount()
    }
    
    func subsribeToNotificationCount() {
        articleDetailsViewModel.notificationCountInstance.subscribe { [weak self] notifincationCount in
            DispatchQueue.main.async {
                self?.notificationButton.badgeValue = "\(notifincationCount.element ?? 0)"
                self?.notificationButton.badgeOffset = CGPoint(x: -10, y: -10)
                UIApplication.shared.applicationIconBadgeNumber = notifincationCount.element ?? 0

            }
        }.disposed(by: self.disposeBag)

    }
    
    func notificationButtonTapped() {
        notificationButton.rx.tap.subscribe { [weak self] _ in
            self?.router.showNotificationList()
        }.disposed(by: self.disposeBag)

    }
    
    func showHomeView() {
        homebutton.rx.tap.subscribe { [weak self] _ in
            self?.articleDetailsViewModel.rootViewtoTabBar()
        } .disposed(by: self.disposeBag)

    }

}
extension UperViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
