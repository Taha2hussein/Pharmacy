//
//  WalletsDetailsViewModel.swift
//  Pharmacy
//
//  Created by A on 23/01/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class WalletsDetailsViewModel {
    
    private weak var view: WalletDetailsViewController?
    private var router: WalletsDetailsRouter?
    
    func bind(view: WalletDetailsViewController, router: WalletsDetailsRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}
