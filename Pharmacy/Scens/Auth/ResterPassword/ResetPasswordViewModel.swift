//
//  ResetPasswordViewModel.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class ResetPasswordViewModel{
    
    private weak var view: ResetPasswordViewController?
    private var router: ResetPasswordRouter?
    
    func bind(view: ResetPasswordViewController, router: ResetPasswordRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}
