//
//  VerificationViewModel.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//


import Foundation
import RxSwift
import RxCocoa
import RxRelay

class VerificationViewModel{
    
    private weak var view: VerificationViewController?
    private var router: VerificationRouter?
    
    func bind(view: VerificationViewController, router: VerificationRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}
