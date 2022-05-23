//
//  MedicineFilterViewModel.swift
//  Pharmacy
//
//  Created by taha hussein on 14/03/2022.
//


import Foundation
import RxSwift
import RxCocoa
import RxRelay
import SwiftUI

class MedicineFilterViewModel{
    
    private weak var view: MedicineFilterViewController?
    private var router: MedicineFilterRouter?
    var  state = State()
    var MedicinCategoryId: Int?
    var medicineFilters = PublishSubject<[FilterCatogrMessage]>()
    var medicineFiltersForBrands = PublishSubject<[FilterBrandMessage]>()

    func bind(view: MedicineFilterViewController, router: MedicineFilterRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }

   
}
extension MedicineFilterViewModel {
    func getFilters(MedicineCategoryFor:Int,MedicineCategoryName:String){
        let parameters = ["MedicineCategoryFor": MedicineCategoryFor,
                          "MedicineCategoryName":MedicineCategoryName
        ] as [String : Any]
        var request = URLRequest(url: URL(string: filterCatogryApi )!)
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
                var FilterCatogry: FilterCatogryModel?
                FilterCatogry = try decoder.decode(FilterCatogryModel.self, from: data)
                print(FilterCatogry , "FindMedicindddd")
                if FilterCatogry?.successtate == 200 {
                    self.view?.showOtherCatoreyCollectionView()
                    self.medicineFilters.onNext(FilterCatogry?.message ?? [])
                }
                
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: FilterCatogry?.errormessage ?? "An error occured , Please try again", viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}

extension MedicineFilterViewModel {
    func getFiltersForBrands(MedicineCategoryName:String){
        let parameters = ["Name":MedicineCategoryName
        ] as [String : Any]
        var request = URLRequest(url: URL(string: filterBrandApi )!)
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
                var FilterCatogryForBrnds: FilterBrandModel?
                FilterCatogryForBrnds = try decoder.decode(FilterBrandModel.self, from: data)
                print(FilterCatogryForBrnds , "FindMedicindddd")
                if FilterCatogryForBrnds?.successtate == 200 {
                    self.view?.showBrandsCollecitonView()
                    self.medicineFiltersForBrands.onNext(FilterCatogryForBrnds?.message ?? [])
                }
                
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: FilterCatogryForBrnds?.errormessage ?? "An error occured , Please try again", viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
