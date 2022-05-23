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
    var state = State()
    
    var branchId = BehaviorRelay<String>(value: "")
    var pharmacyName = BehaviorRelay<String>(value: "")
    var pharmacyLocation = BehaviorRelay<String>(value: "")
    var pharmacyIncome = BehaviorRelay<String>(value: "")
    var pharmacyExpense = BehaviorRelay<String>(value: "")
    var pahrmacyImage = BehaviorRelay<String>(value: "")
    var totalBalance = BehaviorRelay<String>(value: "")
    var totalIncome = BehaviorRelay<String>(value: "")
    var totalExpnse = BehaviorRelay<String>(value: "")
    var walletTransaction = PublishSubject<[walletTransactionMessage]>()
    
    func bind(view: WalletDetailsViewController, router: WalletsDetailsRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func getWalletTransactionList(branchId: String , fromDate: String, endDate: String) {
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string:walletTransactionList)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters = ["BranchId":branchId,
                          "datefrom":fromDate,
                          "dateto":endDate]
        let key = LocalStorage().getLoginToken()
        print("parameters",parameters)
        let authValue: String? = "Bearer \(key)"
        
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        request.httpBody = jsonString?.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                var walletTranscation = WalletTransactionList()
                walletTranscation = try decoder.decode(WalletTransactionList.self, from: data)
                if walletTranscation.successtate == 200 {
                    
                    self.walletTransaction.onNext(walletTranscation.message ?? [])
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}

extension WalletsDetailsViewModel {
    
    func intializeData() {
        if let article = articles {
            self.pharmacyName.accept(article.entityNameLocalized ?? "")
            self.pharmacyLocation.accept(article.branchAddressLocalized ?? "")
            self.pharmacyIncome.accept("\(Int(article.totalIncome ?? 0))")
            self.pharmacyExpense.accept("\(Int(article.totalExpense ?? 0))")
            self.pahrmacyImage.accept(article.imagepath ?? "")
            self.branchId.accept("\(article.pharmacyProviderBranchFk ?? 0)")
            self.view?.animateProgress(incomde: Double(article.totalIncome ?? 0.0), expanse: Double(article.totalExpense ?? 0.0))
        }
    }
}

extension WalletsDetailsViewModel {
    
    func intializeDataForBalance() {
        if let article = Balance  {
            self.totalBalance.accept("\(Int(article.message?.totalBalance ?? 0))")
            self.totalIncome.accept("\(Int(article.message?.totalIncome ?? 0))")
            self.totalExpnse.accept("\(Int(article.message?.totalExpense ?? 0))")
            self.pharmacyIncome.accept("\(Int(article.message?.totalIncome  ?? 0))")
            self.pharmacyExpense.accept("\(Int(article.message?.totalExpense ?? 0))")
            
        }
    }
}

extension WalletsDetailsViewModel: backView {
    func backNavigationview() {
        router?.back()
    }
}
