//
//  PopViewCancelationViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 09/03/2022.
//

import UIKit
import RxCocoa
import RxRelay
import RxSwift

var cancelReasonSelected  = Int()
var cancelRemoveSubview = BehaviorRelay<Bool>(value:false)
var cancelReson = String()
class PopViewCancelationViewController: BaseViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cancelationTableView: UITableView!
    @IBOutlet weak var reasonOfCancel: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    private var cancelReasonsInstance = PublishSubject<[CancelReasonsMessage]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindBranchToTableView()
        selectBranch()
        getCancelResons()
        removePopview()
    }
    
    func bindBranchToTableView() {
        self.cancelReasonsInstance
            .bind(to: self.cancelationTableView
                    .rx
                    .items(cellIdentifier: String(describing:  PopCancelViewCell.self),
                           cellType: PopCancelViewCell.self)) { row, model, cell in
                cell.cancelLabel.text = model.cancellationReasonNameLocalized
//                cancelRemoveSubview.accept(true)
              
            }.disposed(by: self.disposeBag)
    }
    
    func selectBranch() {
        Observable.zip(cancelationTableView
                        .rx
                        .itemSelected,cancelationTableView.rx.modelSelected(CancelReasonsMessage.self)).bind { [weak self] selectedIndex, product in
            cancelReasonSelected = product.cancellationReasonID ?? 0
            cancelReson = self?.reasonOfCancel.text ?? ""
            cancelRemoveSubview.accept(true)
            self?.view.removeFromSuperview()
        }.disposed(by: self.disposeBag)
    }
    
    func removePopview() {
        cancelButton.rx
            .tap.subscribe { [weak self] _ in
                self?.view.removeFromSuperview()
            }.disposed(by: self.disposeBag)
    }
    
    

}


extension PopViewCancelationViewController {
    func getCancelResons() {
        var request = URLRequest(url: URL(string: cancelOrderReasonsApi )!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
//        state.isLoading.accept(true)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
//            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                var cancelReasons : CancelReasons?
                cancelReasons = try decoder.decode(CancelReasons.self, from: data)
                print(cancelReasons , "cancelReasons")
                if cancelReasons?.successtate == 200 {
                    
                    self.cancelReasonsInstance.onNext(cancelReasons?.message ?? [])
                }
                
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: cancelReasons?.errormessage ?? "An error occured , Please try again", viewController: self)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
