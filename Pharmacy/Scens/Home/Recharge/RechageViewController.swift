//
//  RechageViewController.swift
//  Pharmacy
//
//  Created by A on 26/01/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class RechageViewController: BaseViewController {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    private var state = State()
    private var rechaegeResponse = RechargeModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        closeAction()
        doneAction()
        subscribeToLoader()
    }
    
    func closeAction() {
        closeButton.rx.tap.subscribe { [weak self] _ in
            self?.closeView()
        }.disposed(by: self.disposeBag)
        
    }
    
    func showAlert(message:String) {
        Alert().displayError(text: message, viewController: self)
    }
    
    func validateALLField() {
        if amountTextField.text!.isEmpty {
            showAlert(message: LocalizedStrings().emptyField)
        }
        
        else {
            self.rechargeAmount(amount: self.amountTextField.text ?? "")
        }
        
    }
    
    func doneAction() {
        doneButton.rx.tap.subscribe { [weak self] _ in
            self?.validateALLField()
        }.disposed(by: self.disposeBag)
        
    }
    
    func closeView(){
        self.view.removeFromSuperview()
    }
    
    func subscribeToLoader() {
        self.state.isLoading.subscribe(onNext: {[weak self] (isLoading) in
            DispatchQueue.main.async {
                if isLoading {
                    
                    self?.showLoading()
                    
                } else {
                    self?.hideLoading()
                }
            }
        }).disposed(by: self.disposeBag)
    }
    
    func getCurrentDate()-> String {
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        let result = formatter.string(from: date)
        return result
    }
    
    func rechargeAmount(amount: String) {
        
        let currentDate = getCurrentDate()
        let parameters = ["Amount":Int(amount) ?? 0,
                          "CurrencyFk":1,
                          "PaymentType":2,
                          "PharmacyBranchFk":53,
                          "TransactionDate":currentDate] as [String : Any]
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: rechargePharmacy)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let key = LocalStorage().getLoginToken()
        print(parameters)
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        request.httpBody = jsonString?.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                self.rechaegeResponse = try decoder.decode(RechargeModel.self, from: data)
                DispatchQueue.main.async {
                    print(self.rechaegeResponse)
                    self.closeView()
                }
                
            } catch let err {
                print("Err", err)
            }
        }.resume()
        
    }
}

