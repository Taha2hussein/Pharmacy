//
//  FindAlternativeViewModel.swift
//  Pharmacy
//
//  Created by taha hussein on 13/03/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import SwiftUI

class FindAlternativeViewModel{
    
    private weak var view: FindAlternativeViewController?
    private var router: FindAlternativeRouter?
    var  state = State()
    var orderType: orderTypeSelected?,MedicinCategoryId: Int? , MedicineType: Int?
    var Medicine = PublishSubject<[Medicine]>()
    func bind(view: FindAlternativeViewController, router: FindAlternativeRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }

   
}

extension FindAlternativeViewModel {
    func getAllMdeicine(){
        let parameters = ["PageNum": 1,
                          "RowNum":100,
                          "CompanyId":LocalStorage().getBrandFilter()]
        var request = URLRequest(url: URL(string: findMedicineApi )!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        request.httpBody = jsonString?.data(using: .utf8)
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        state.isLoading.accept(true)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                var FindMedicin: FindMedicinModel?
                FindMedicin = try decoder.decode(FindMedicinModel.self, from: data)
                print(FindMedicin , "FindMedicin")
                if FindMedicin?.successtate == 200 {
                    
                    self.Medicine.onNext(FindMedicin?.message?.medicines ?? [])
                }
                
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: FindMedicin?.errormessage ?? "An error occured , Please try again", viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}


extension FindAlternativeViewModel {
    func getAlternative() {
        let parameters = ["PageNum": 1,
                          "RowNum":100,
                          "MedicinCategoryId":MedicinCategoryId,
                          "MedicineType":MedicineType,
                          ]
        var request = URLRequest(url: URL(string: findMedicineApi )!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        request.httpBody = jsonString?.data(using: .utf8)
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        state.isLoading.accept(true)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                var medicineAlternative: FindMedicinModel?
                medicineAlternative = try decoder.decode(FindMedicinModel.self, from: data)
                print(medicineAlternative , "medicineAlternative")
                if medicineAlternative?.successtate == 200 {
                    
                    self.Medicine.onNext(medicineAlternative?.message?.medicines ?? [])
                }
                
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: medicineAlternative?.errormessage ?? "An error occured , Please try again", viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
