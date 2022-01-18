//
//  ForgetViewModel.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class ForgetViewModel{
    
    private weak var view: ForgetViewController?
    private var router: ForgetPasswordRouter?
    
    func bind(view: ForgetViewController, router: ForgetPasswordRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}
