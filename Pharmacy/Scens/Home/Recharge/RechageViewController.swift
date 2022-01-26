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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeAction()
        doneAction()
    }
    
    func closeAction() {
        closeButton.rx.tap.subscribe { [weak self] _ in
            self?.closeView()
        }.disposed(by: self.disposeBag)

    }
    
    func doneAction() {
        doneButton.rx.tap.subscribe { [weak self] _ in
            defer{
                self?.closeView()
            }
        }.disposed(by: self.disposeBag)

    }
    
    func closeView(){
        self.view.removeFromSuperview()
    }
}
