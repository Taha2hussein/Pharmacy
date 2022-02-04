//
//  MoreViewModel.swift
//  Pharmacy
//
//  Created by A on 30/01/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class MoreViewModel{
    
    private weak var view: MoreViewController?
    private var router: MoreRouter?
    
    func bind(view: MoreViewController, router: MoreRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func showProfile() {
        router?.showProfile()
    }
}

extension MoreViewModel: uperSection {
    func embedUperView(uperView: UIView) {
        router?.embedUperView(uperView: uperView)
    }
    
    func showBlogs() {
        router?.showBlogs()
    }
}
