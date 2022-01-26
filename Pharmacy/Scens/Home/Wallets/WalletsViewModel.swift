//
//  WalletsViewModel.swift
//  Pharmacy
//
//  Created by A on 20/01/2022.
//
import Foundation
import RxSwift
import RxCocoa
import RxRelay

class WalletsViewModel{
    
    private weak var view: WalletsViewController?
    private var router: WalletsRouter?
    var state = State()
    var wallet = PublishSubject<WalletModel>()
    var walletBrhacnList = PublishSubject<[BrahcnListMessage]>()
    func bind(view: WalletsViewController, router: WalletsRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func getWallet() {
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: walletSummary)!)
        request.httpMethod = "GET"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiMDEwMTQ3ODUyMzYiLCJqdGkiOiIyYTk4NTVjNy1hMDQ4LTQzYjYtOTlhMy05OTkzM2NhZTVlYTgiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOlsiUGF0aWVudCIsIlBoYXJtYWNpc3QiLCJQaGFybWFjeUFkbWluIl0sImV4cCI6MTY3MTc5MDA5NiwiaXNzIjoid3d3LmNsaW5pYy5jb20iLCJhdWQiOiJ3d3cuY2xpbmljLmNvbSJ9.VQGRr-YR9MzwHzEF7AQaQgbCLuDpN-G1AzGMKyJxjFY"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                let decoder = JSONDecoder()
                var walletElement = WalletModel()
                walletElement = try decoder.decode(WalletModel.self, from: data)
                if walletElement.successtate == 200 {
                    self.wallet.onNext(walletElement)
                    }
//
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
    
    func getWalletBranches(fromDate: String , endDate: String) {
        
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string:walletBrnach)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters = ["datefrom":fromDate,
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
                var walletBranch = BrnachListModel()
                walletBranch = try decoder.decode(BrnachListModel.self, from: data)
                print(walletBranch)
                if walletBranch.successtate == 200 {
                    DispatchQueue.main.async {
                        self.walletBrhacnList.onNext(walletBranch.message ?? [])
                    }
                }
              
            } catch let err {
                print("Err", err)
            }
        }.resume()
       
    }
    
    func showDetailsForBrahnch<T>(source: T ){
        router?.navigateToDetailsView(source: source)
    }
}
