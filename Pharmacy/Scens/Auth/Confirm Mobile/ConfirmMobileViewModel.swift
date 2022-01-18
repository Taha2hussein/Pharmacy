//
//  ConfirmMobileViewModel.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class ConfirmMobileViewModel{
    
    private weak var view: ConfirmMobileViewController?
    private var router: ConfirmMobileRouter?
    
    func bind(view: ConfirmMobileViewController, router: ConfirmMobileRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}
