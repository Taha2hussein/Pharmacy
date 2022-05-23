//
//  OrderCanceledViewModel.swift
//  Pharmacy
//
//  Created by taha hussein on 08/03/2022.
//


import Foundation
import RxSwift
import RxCocoa
import RxRelay
import SwiftUI

class OrderCanceledViewModel{
    
    private weak var view: OrderCancelViewController?
    private var router: OrderCancelRouter?
    var  state = State()
    var orderId = Int()
    var singleOrderStatus = Int()
    var canceledOrdersInstance = PublishSubject<CanceledOrderMessage>()
    var cancelOrderSummary = PublishSubject <[PharmacyOrderItem]>()
    func bind(view: OrderCancelViewController, router: OrderCancelRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func getOrderDetails() {
        let parameters = ["OrderID": orderId
                          ,"PharmacyID": LocalStorage().getPharmacyProviderFk(),
                          "BranchID":0]
        var request = URLRequest(url: URL(string: cancelOrderApi)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        print(parameters,  key ,"parameters")

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
                var cancelOrder : CanceledOrder?
                cancelOrder = try decoder.decode(CanceledOrder.self, from: data)
                if cancelOrder?.successtate == 200 {
                    if let cancelOrderMessaege = cancelOrder?.message {
                    self.canceledOrdersInstance.onNext(cancelOrderMessaege)
                        self.cancelOrderSummary.onNext(cancelOrderMessaege.pharmacyOrderItem ?? [])
                    }
                    
                }
                
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: cancelOrder?.errormessage ?? "An error occured , Please try again".localized, viewController: self.view!)
    
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
    
}
