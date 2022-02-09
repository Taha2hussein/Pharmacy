//
//  PharmacyProfileViewModel.swift
//  Pharmacy
//
//  Created by A on 08/02/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class PharmacyProfileViewModel{
    
    private weak var view: PharmacyProfileViewController?
    private var router: PharmacyProfileRouter?
    
    func bind(view: PharmacyProfileViewController, router: PharmacyProfileRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}
