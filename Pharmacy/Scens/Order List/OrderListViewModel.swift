//
//  OrderListViewModel.swift
//  Pharmacy
//
//  Created by taha hussein on 08/03/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import SwiftUI

class OrderListViewModel{
    
    private weak var view: OrderListViewController?
    private var router: OrderListRouter?
    var  state = State()
    var ordersInstance = PublishSubject<[OrderListMessage]>()
    func bind(view: OrderListViewController, router: OrderListRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
}

extension OrderListViewModel {
    func getOrderList(segmentSelected: Int) {


        let parameters = ["OrderStatus": segmentSelected
                          ,"PageNum": 1,
                          "RowNum":10] as [String : Any]
        var request = URLRequest(url: URL(string: orderListApi)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiMDEwMTQ3ODUyMzYiLCJqdGkiOiIyYTk4NTVjNy1hMDQ4LTQzYjYtOTlhMy05OTkzM2NhZTVlYTgiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOlsiUGF0aWVudCIsIlBoYXJtYWNpc3QiLCJQaGFybWFjeUFkbWluIl0sImV4cCI6MTY3MTc5MDA5NiwiaXNzIjoid3d3LmNsaW5pYy5jb20iLCJhdWQiOiJ3d3cuY2xpbmljLmNvbSJ9.VQGRr-YR9MzwHzEF7AQaQgbCLuDpN-G1AzGMKyJxjFY"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        request.httpBody = jsonString?.data(using: .utf8)
        state.isLoading.accept(true)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                var order : OrderList?
                order = try decoder.decode(OrderList.self, from: data)
                if order?.successtate == 200 {
                    self.ordersInstance.onNext(order?.message ?? [])
                    
                }
                
                else {
                    DispatchQueue.main.async {
                    Alert().displayError(text: order?.errormessage ?? "An error occured , Please try again", viewController: self.view!)
    
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
    
    
}