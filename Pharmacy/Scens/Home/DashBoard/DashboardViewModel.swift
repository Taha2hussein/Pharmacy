//
//  DashboardViewModel.swift
//  Pharmacy
//
//  Created by A on 20/01/2022.
//

import Foundation
import Foundation
import RxSwift
import RxCocoa
import RxRelay

class DashboardViewModel{
    
    private weak var view: DashboardViewController?
    private var router: DashboardRouter?
    var dashBoard = PublishSubject<DashboardModel>()
    var dailyTotalOrders = PublishSubject<[TotalDailyOrdersBranch]>()
    var branchesObject = PublishSubject<[Branch]>()
    var dashBoardList = PublishSubject<[PharmacyDashboardBranchesMessage]>()
    var state = State()
    
    func bind(view: DashboardViewController, router: DashboardRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func getDashboard() {
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: dashboardApi)!)
        request.httpMethod = "GET"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiMDEwMTQ3ODUyMzYiLCJqdGkiOiIyYTk4NTVjNy1hMDQ4LTQzYjYtOTlhMy05OTkzM2NhZTVlYTgiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOlsiUGF0aWVudCIsIlBoYXJtYWNpc3QiLCJQaGFybWFjeUFkbWluIl0sImV4cCI6MTY3MTc5MDA5NiwiaXNzIjoid3d3LmNsaW5pYy5jb20iLCJhdWQiOiJ3d3cuY2xpbmljLmNvbSJ9.VQGRr-YR9MzwHzEF7AQaQgbCLuDpN-G1AzGMKyJxjFY"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                let decoder = JSONDecoder()
                var DashboardElement = DashboardModel()
                DashboardElement = try decoder.decode(DashboardModel.self, from: data)
                if DashboardElement.successtate == 200 {
                    self.dashBoard.onNext(DashboardElement)
                    self.dailyTotalOrders.onNext(DashboardElement.message?.totalDailyOrdersBranches ?? [])
                    self.branchesObject.onNext(DashboardElement.message?.branches ?? [])
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
    
    func getBranchList(month: Int , year: Int  ) {
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string:PharmacyDashboardBranchesApi)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters = ["Month":month,
                          "Year":year]
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
                var dashBoearBranch = PharmacyDashboardBranches()
                dashBoearBranch = try decoder.decode(PharmacyDashboardBranches.self, from: data)
                print(parameters , dashBoearBranch)
                if dashBoearBranch.successtate == 200 {

                    self.branchesObject.onNext(dashBoearBranch.message?.branches ?? [])
                }
                
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
