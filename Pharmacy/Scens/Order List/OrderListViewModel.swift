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
    var ordersInstance = BehaviorSubject<[OrderListMessage]>(value: [])
    var ordersInstanceTemp = BehaviorSubject<[OrderListMessage]>(value: [])

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
                          "RowNum":100] as [String : Any]
        var request = URLRequest(url: URL(string: orderListApi)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        request.httpBody = jsonString?.data(using: .utf8)
        state.isLoading.accept(true)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                var order : OrderListModel?
                order = try decoder.decode(OrderListModel.self, from: data)

                if order?.successtate == 200 {
                    self.ordersInstance.onNext(order?.message ?? [])
                    self.ordersInstanceTemp.onNext(order?.message ?? [])
                    self.view?.validateEmptyOrders()
                }
                
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: order?.errormessage ?? "An error occured , Please try again".localized, viewController: self.view!)
    
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
    
    
}
