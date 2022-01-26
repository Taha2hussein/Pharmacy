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
        let authValue: String? = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiMDEwMTQ3ODUyMzYiLCJqdGkiOiIyYTk4NTVjNy1hMDQ4LTQzYjYtOTlhMy05OTkzM2NhZTVlYTgiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOlsiUGF0aWVudCIsIlBoYXJtYWNpc3QiLCJQaGFybWFjeUFkbWluIl0sImV4cCI6MTY3MTc5MDA5NiwiaXNzIjoid3d3LmNsaW5pYy5jb20iLCJhdWQiOiJ3d3cuY2xpbmljLmNvbSJ9.VQGRr-YR9MzwHzEF7AQaQgbCLuDpN-G1AzGMKyJxjFY"
        
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
                print("walletTranscation" , walletTranscation)
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
        if let article = articles as? BrahcnListMessage {
            self.pharmacyName.accept(article.entityNameLocalized ?? "")
            self.pharmacyLocation.accept(article.branchAddressLocalized ?? "")
            self.pharmacyIncome.accept("\(Int(article.totalIncome ?? 0))")
            self.pharmacyExpense.accept("\(Int(article.totalExpense ?? 0))")
            self.pahrmacyImage.accept(article.imagepath ?? "")
            self.branchId.accept("\(article.pharmacyProviderBranchFk ?? 0)")
        }
    }
}


extension WalletsDetailsViewModel {
    
    func intializeDataForBalance() {
        if let article = Balance as? WalletModel {
            self.totalBalance.accept("\(Int(article.message?.totalBalance ?? 0))")
            self.totalIncome.accept("\(Int(article.message?.totalIncome ?? 0))")
            self.totalExpnse.accept("\(Int(article.message?.totalExpense ?? 0))")
            self.pharmacyIncome.accept("\(Int(article.message?.totalIncome  ?? 0))")
            self.pharmacyExpense.accept("\(Int(article.message?.totalExpense ?? 0))")

        }
    }
}
