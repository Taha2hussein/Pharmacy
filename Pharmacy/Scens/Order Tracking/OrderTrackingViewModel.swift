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

class OrderTrackingViewModel {
    
    private weak var view: OrderTrackingViewController?
    private var router: OrderTrackingRouter?
    var  state = State()
    var orderId = Int()
    var singleOrderStatus = Int()
    var orderTrackingInstance = PublishSubject<OrderTrackingMessage>()
    var orderTrackingFiles = PublishSubject<[PharmacyOrderFile]>()
    var orderTrackingSummary = PublishSubject<[OrderTrackingPharmacyOrderItem]>()
    var acceptOrder = PublishSubject<AcceptPharmacyOrder>()
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
print(parameters, "parametersssdff")
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
                        self.orderTrackingFiles.onNext(ordertracking.pharmacyOrderFile ?? [])
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


extension OrderTrackingViewModel {
    func acceptOrder(BranchID: Int) {
        let parameters = ["OrderID": orderId
                          ,"PharmacyID": LocalStorage().getPharmacyProviderFk(),
                          "BranchID":BranchID]
        var request = URLRequest(url: URL(string: acceptPharmacyOrederApi)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"

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
                var acceptOrder : AcceptPharmacyOrder?
                acceptOrder = try decoder.decode(AcceptPharmacyOrder.self, from: data)
                if acceptOrder?.successtate == 200 {
                    DispatchQueue.main.async {
                        removeSubview.accept(false)
                        self.view?.showReceivedView()
                    }
                }
                else {
                    DispatchQueue.main.async {
                    Alert().displayError(text: acceptOrder?.errormessage ?? "An error occured , Please try again", viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}


extension OrderTrackingViewModel {
    func cancelOrder(BranchID: Int) {
        let parameters = ["OrderID": orderId
                          ,"PharmacyID": LocalStorage().getPharmacyProviderFk(),
                          "BranchID":BranchID,
                          "Reason":cancelReson,
                          "ReasonId":cancelReasonSelected] as [String : Any]
        var request = URLRequest(url: URL(string: rejectOrderApi)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"

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
                var rejectOrder : RejectOrderModel?
                rejectOrder = try decoder.decode(RejectOrderModel.self, from: data)
                if rejectOrder?.successtate == 200 {
                    DispatchQueue.main.async {
                        cancelRemoveSubview.accept(false)
                        removeSubview.accept(false)
                        self.router?.backAction()
                    }
                }
                else {
                    DispatchQueue.main.async {
                    Alert().displayError(text: rejectOrder?.errormessage ?? "An error occured , Please try again", viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}


extension OrderTrackingViewModel {
    func acceptPricing(offerId: Int) {
        
        var request = URLRequest(url: URL(string: accectPricingApi + "\(offerId)")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"

        request.setValue(authValue, forHTTPHeaderField: "Authorization")
print(request)
        state.isLoading.accept(true)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                var acceptPricing : AcceptPricingModel?
                acceptPricing = try decoder.decode(AcceptPricingModel.self, from: data)
                if acceptPricing?.successtate == 200 {
                    DispatchQueue.main.async {
                        cancelRemoveSubview.accept(false)
                        saveOrderForCusomerSuccess.onNext(false)
                        removeSubview.accept(false)
                        self.router?.backAction()
                    }
                }
                else {
                    DispatchQueue.main.async {
                    Alert().displayError(text: acceptPricing?.errormessage ?? "An error occured , Please try again", viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}


extension OrderTrackingViewModel {
    func finishOrder(offerId: Int) {
        
        var request = URLRequest(url: URL(string: finishOrderApi + "\(offerId)")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"

        request.setValue(authValue, forHTTPHeaderField: "Authorization")
print(request)
        state.isLoading.accept(true)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                var finishOrderIsntance : FinishOrderModel?
                finishOrderIsntance = try decoder.decode(FinishOrderModel.self, from: data)
                if finishOrderIsntance?.successtate == 200 {
                    DispatchQueue.main.async {
                        toggleFinishOrderView.onNext(false)
                        cancelRemoveSubview.accept(false)
                        saveOrderForCusomerSuccess.onNext(false)
                        removeSubview.accept(false)
                        self.router?.backAction()
                    }
                }
                else {
                    DispatchQueue.main.async {
                    Alert().displayError(text: finishOrderIsntance?.errormessage ?? "An error occured , Please try again", viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
