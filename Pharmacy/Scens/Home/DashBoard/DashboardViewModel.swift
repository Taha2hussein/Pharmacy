//
//  DashboardViewModel.swift
//  Pharmacy
//
//  Created by A on 20/01/2022.
//

import Foundation
import Foundation
import RxSwift
import RxCocoa
import RxRelay

class DashboardViewModel{
    
    private weak var view: DashboardViewController?
    private var router: DashboardRouter?
    
    func sdf(){
        print("sdfsdfdsf")
    }
    func bind(view: DashboardViewController, router: DashboardRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}
