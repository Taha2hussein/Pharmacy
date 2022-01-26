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
    var articles: BrahcnListMessage?
    
    var pharmacyName = BehaviorRelay<String>(value: "")
    var pharmacyLocation = BehaviorRelay<String>(value: "")
    var pharmacyIncome = BehaviorRelay<String>(value: "")
    var pharmacyExpense = BehaviorRelay<String>(value: "")
    var pahrmacyImage = BehaviorRelay<String>(value: "")

    func bind(view: WalletDetailsViewController, router: WalletsDetailsRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}

extension WalletsDetailsViewModel {
    
    func intializeData() {
        if let article = articles as? BrahcnListMessage {
            self.pharmacyName.accept(article.entityNameLocalized ?? "")
            self.pharmacyLocation.accept(article.branchAddressLocalized ?? "")
            self.pharmacyIncome.accept("\(Int(article.totalIncome ?? 0))")
            self.pharmacyExpense.accept("\(Int(article.totalExpense ?? 0))")
            self.pahrmacyImage.accept(article.imagepath ?? "")

        }
    }
}
