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
    private weak var router: WalletsDetailsRouter?
    
    var articles: BrahcnListMessage?
    var Balance: WalletModel?
    
    var pharmacyName = BehaviorRelay<String>(value: "")
    var pharmacyLocation = BehaviorRelay<String>(value: "")
    var pharmacyIncome = BehaviorRelay<String>(value: "")
    var pharmacyExpense = BehaviorRelay<String>(value: "")
    var pahrmacyImage = BehaviorRelay<String>(value: "")
    var totalBalance = BehaviorRelay<String>(value: "")
    var totalIncome = BehaviorRelay<String>(value: "")
    var totalExpnse = BehaviorRelay<String>(value: "")
    
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


extension WalletsDetailsViewModel {
    
    func intializeDataForBalance() {
        print(Balance, "Balance")
        if let article = Balance as? WalletModel {
            self.totalBalance.accept("\(Int(article.message?.totalBalance ?? 0))")
            self.totalIncome.accept("\(Int(article.message?.totalIncome ?? 0))")
            self.totalExpnse.accept("\(Int(article.message?.totalExpense ?? 0))")
            self.pharmacyIncome.accept("\(Int(article.message?.totalIncome  ?? 0))")
            self.pharmacyExpense.accept("\(Int(article.message?.totalExpense ?? 0))")

        }
    }
}
