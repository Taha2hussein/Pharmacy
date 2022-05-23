//
//  PricingViewModel.swift
//  Pharmacy
//
//  Created by taha hussein on 12/03/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import SwiftUI

var saveOrderForCusomerSuccess = PublishSubject<Bool>()
class PricingViewModel{
    
    private weak var view: PricingViewController?
    private var router: PricingRouter?
    var  state = State()
    var OrderTrackingMessage: OrderTrackingMessage?
    var orderItems = PublishSubject<[OrderTrackingPharmacyOrderItem]>()
    func bind(view: PricingViewController, router: PricingRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }

    func setup() {
        if let orderItems = OrderTrackingMessage?.pharmacyOrderItem {
            self.orderItems.onNext(orderItems)
        }
    }
    
    func saveDataToCustomer(alternativeMedicine: [Medicine],discount:Double) {
        
        var membersArray = [Any]()
         for i in 0..<alternativeMedicine.count {
             var quantity = 0
             if  let quauntityCheck = alternativeMedicine[i].medicineAmountDetailsLocalized?.isNumeric {
             if quauntityCheck {
                 quantity = 0
             }
             else {
                 quantity = alternativeMedicine[i].numberOfCart ?? 0
                }
             }
             
             let json: [String: Any]  = [
                 "PharmacyOrderOfferItemId": 0,
                 "OrderOfferFk": 0,
                 "PharmacyOrderItemFk": 0,
                 "MedicationFk":alternativeMedicine[i].medicationID ?? 0,
                 "Quantity":quantity,
                 "ItemFees":alternativeMedicine[i].price ?? 0,
                 "IsAlternative":true,
                 "IsAvaliable":true
             ]
             membersArray.append(json)
         }
        
        let parameters = [ "PharmacyProviderFk": LocalStorage().getPharmacyProviderFk(),
                           "HasDelivery":OrderTrackingMessage?.hasDelivery ?? false,
                           "IsOnlinePayment":OrderTrackingMessage?.isOnlinePayment ?? false,
                           "OrderFk":OrderTrackingMessage?.orderID ?? 0,
                           "OfferNotes":OrderTrackingMessage?.currentOffer?.offerNotes ?? "",
                           "OrderDiscount":discount,
                           "OrderFees":OrderTrackingMessage?.currentOffer?.orderFees ?? 0,
                           "PharmacyOrderOfferId":0,
                           "CreatedByFk":LocalStorage().getPharmacsitID(),
                           "DeliveryFees": 0 ,
                           "DeliveryTimeInMinuts":0,
                           "PharmacyProviderBranchFk":branchSelected,
                           "PharmacyOrderOfferItemList":membersArray] as [String : Any]
        
        var request = URLRequest(url: URL(string: saveOrderToCustomer)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        print(parameters ,"parameters")

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
                var saveOrder : SaveOrderToCustomer?
                saveOrder = try decoder.decode(SaveOrderToCustomer.self, from: data)
                if saveOrder?.successtate == 200 {
//                    if let saveOrderMessage = saveOrder?.message {
                        DispatchQueue.main.async {
                            saveOrderForCusomerSuccess.onNext(true)
                            self.router?.backAction()
                            print(saveOrder?.message , "zzzxsdf")
                        }
           
                    }
                    
//                }
                
                else {
                    DispatchQueue.main.async {
                    Alert().displayError(text: saveOrder?.errormessage ?? "An error occured , Please try again", viewController: self.view!)
    
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}

extension String {
    var isNumeric : Bool {
        return Double(self) != nil
    }
}
