//
//  PreparingOrderViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 13/05/2022.
//

import UIKit
import RxCocoa
import RxRelay
import RxSwift

class PreparingOrderViewController: BaseViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var minutesTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black.withAlphaComponent(0.5)
        doneAction()
        closeAction()
    }
    
    
    func closeAction() {
        closeButton.rx.tap.subscribe { [weak self] _ in
            self?.view.removeFromSuperview()
        }.disposed(by: self.disposeBag)
    }
    
    func doneAction() {
        doneButton.rx.tap.subscribe { [weak self] _ in
            singlton.shared.deliverytime = self?.minutesTextField.text ?? "0"
            self?.view.removeFromSuperview()
        }.disposed(by: self.disposeBag)

    }



}
