//
//  OrderDeliveredViewModel.swift
//  Pharmacy
//
//  Created by taha hussein on 08/03/2022.
//



import Foundation
import RxSwift
import RxCocoa
import RxRelay
import SwiftUI

class OrderDeliveredViewModel{
    
    private weak var view: OrderDeliveredViewController?
    private var router: OrderDeliveredRouter?
    var  state = State()
    var orderId = Int()
    var canceledOrdersInstance = PublishSubject<CanceledOrderMessage>()
    
    func bind(view: OrderDeliveredViewController, router: OrderDeliveredRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func getOrderDetails() {
        let parameters = ["OrderID": orderId
                          ,"PharmacyID": LocalStorage().getPharmacyProviderFk()]
        var request = URLRequest(url: URL(string: cancelOrderApi)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        print(parameters,  key ,"parameters")

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
                var cancelOrder : CanceledOrder?
                cancelOrder = try decoder.decode(CanceledOrder.self, from: data)
                if cancelOrder?.successtate == 200 {
                    if let cancelOrderMessaege = cancelOrder?.message {
                    self.canceledOrdersInstance.onNext(cancelOrderMessaege)
                    }
                    
                }
                
                else {
                    DispatchQueue.main.async {
                    Alert().displayError(text: cancelOrder?.errormessage ?? "An error occured , Please try again", viewController: self.view!)
    
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
    
}
