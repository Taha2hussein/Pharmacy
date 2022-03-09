//
//  OrderTrackingViewModel.swift
//  Pharmacy
//
//  Created by taha hussein on 09/03/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class OrderTrackingViewModel{
    
    private weak var view: OrderTrackingViewController?
    private var router: OrderTrackingRouter?
    var  state = State()
    var orderId = Int()

    var orderTrackingInstance = PublishSubject<OrderTrackingMessage>()
    var orderTrackingSummary = PublishSubject<[OrderTrackingPharmacyOrderItem]>()
    
    func bind(view: OrderTrackingViewController, router: OrderTrackingRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    
    
}

extension OrderTrackingViewModel {
    func getOrderTracking() {
        let parameters = ["OrderID": orderId
                          ,"PharmacyID": LocalStorage().getPharmacyProviderFk(),
                          "BranchID":0]
        var request = URLRequest(url: URL(string: orderTrackingApi)!)
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
                var orderTracking : OrderTrackingModel?
                orderTracking = try decoder.decode(OrderTrackingModel.self, from: data)
                if orderTracking?.successtate == 200 {
                    if let ordertracking = orderTracking?.message {
                        self.orderTrackingInstance.onNext(ordertracking)
                        self.orderTrackingSummary.onNext(orderTracking?.message?.pharmacyOrderItem ?? [])
                    }
                    
                }
                
                else {
                    DispatchQueue.main.async {
                    Alert().displayError(text: orderTracking?.errormessage ?? "An error occured , Please try again", viewController: self.view!)
    
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
