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
    var dailyTotalOrders = PublishSubject<[TotalDailyOrder]>()
    var dailyBranches = PublishSubject<[TotalDailyOrdersBranch]>()
    var branchesObject = PublishSubject<[Branch]>()
    var dashBoardList = PublishSubject<[PharmacyDashboardBranchesMessage]>()
    var state = State()
    
    func bind(view: DashboardViewController, router: DashboardRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func getDashboard(fromDate:String , endDate:String) {
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: dashboardApi)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters = ["DateFrom": endDate,
                          "DateTo":fromDate]
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        print("zzzzz" , parameters , key)
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        request.httpBody = jsonString?.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                let decoder = JSONDecoder()
                var DashboardElement:DashboardModel?
                DashboardElement = try decoder.decode(DashboardModel.self, from: data)
                if DashboardElement?.successtate == 200 {
                    self.dashBoard.onNext(DashboardElement!)
//                    self.dailyTotalOrders.onNext(DashboardElement?.message?.totalDailyOrders ?? [])
                    self.branchesObject.onNext(DashboardElement?.message?.branches ?? [])
                    self.dailyBranches.onNext(DashboardElement?.message?.totalDailyOrdersBranches ?? [])
                }
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: DashboardElement?.errormessage ?? "An error occured , Please try again", viewController: self.view!)
                    }
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

extension DashboardViewModel {
    func getTotalDialyOderWithSpecificBranch(fromDate: String , toDate: String , branchId: Int) {
    state.isLoading.accept(true)
    var request = URLRequest(url: URL(string:totalDialyOrdersApi)!)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    let parameters = ["DateTo":fromDate,
                      "DateFrom":toDate,
                      "BranchId":branchId] as [String : Any]
    let key = LocalStorage().getLoginToken()
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
            var dailyTotalrders : TotalDialyOrdersModel?
            dailyTotalrders = try decoder.decode(TotalDialyOrdersModel.self, from: data)
            print(parameters, "ssdd")

            if dailyTotalrders?.successtate == 200 {

                self.dailyTotalOrders.onNext(dailyTotalrders?.message?.totalDailyOrders ?? [])
            }
            
        } catch let err {
            print("Err", err)
        }
    }.resume()
    }
    
}
