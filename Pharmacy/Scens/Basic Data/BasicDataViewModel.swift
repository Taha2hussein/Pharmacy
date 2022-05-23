//
//  BasicDataViewModel.swift
//  Pharmacy
//
//  Created by taha hussein on 23/04/2022.
//

import UIKit
import RxRelay
import RxCocoa
import RxSwift
class BasicDataViewModel{
    
    private weak var view: BasicDataViewController?
    private var router: BasicDataRouter?

    var state = State()
    var Files = BehaviorSubject<[File]>(value: [])
   var basicData = PublishSubject<BasicDataModel>()
    let selectedImageOwner = PublishSubject<UIImage>()
    let selectedImagesForLicence =  BehaviorSubject<[UIImage]>(value: [])

    func bind(view: BasicDataViewController, router: BasicDataRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}

extension BasicDataViewModel {
    func getBasicData() {
        let prharcyId = LocalStorage().getPharmacyProviderFk()
        var request = URLRequest(url: URL(string: basicDataApi  + "\(prharcyId)")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
        state.isLoading.accept(true)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                var basicData = BasicDataModel()
                basicData = try decoder.decode(BasicDataModel.self, from: data)
                if basicData.successtate == 200 {
                    self.Files.onNext(basicData.message?.files ?? [])
                    self.basicData.onNext(basicData)
                }
                
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: basicData.errormessage ?? "An error occured , Please try again".localized, viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}

extension BasicDataViewModel {
    func updateBasicData(BasicData: BasicData,image:String) {

        
        let parameters = [ "PharmacyProviderID": LocalStorage().getPharmacyProviderFk(),
                           "Image":image ,
                           "PharmacyNameEn":BasicData.pharmacyNameEn,
                           "PharmacyNameAr":BasicData.pharmacyNameAr,
                           "AboutPharmacyAr":BasicData.pharmacyAboutAr,
                           "AboutPharmacyEn":BasicData.pharmacyAboutEn ,
                           "TimeToRespondTheOrderInHours":BasicData.TimeToRespondTheOrderInHours ,
                           "Files":BasicData.Files
                         ] as [String : Any]
        
        var request = URLRequest(url: URL(string: updateBasicDataApi)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        print(parameters ,"parameters")
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
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
                var UpdateBasicData : UpdateBasicDataModel?
                UpdateBasicData = try decoder.decode(UpdateBasicDataModel.self, from: data)
                if UpdateBasicData?.successtate == 200 {
//                    if let saveOrderMessage = saveOrder?.message {
                        DispatchQueue.main.async {
//                            saveOrderForCusomerSuccess.onNext(true)
                            self.router?.backAction()
                            print(UpdateBasicData?.message , "zzzxsdf")
                        }
           
                    }
                    
//                }
                
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: UpdateBasicData?.errormessage ?? "An error occured , Please try again".localized, viewController: self.view!)
    
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
