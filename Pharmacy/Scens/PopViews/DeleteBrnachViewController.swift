//
//  DeleteBrnachViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 23/04/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
class DeleteBrnachViewController: BaseViewController {

    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var nobutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yesButtonAction()
        noButtonAction()
        self.view.backgroundColor = .black.withAlphaComponent(0.5)

    }
    

    func yesButtonAction() {
        yesButton.rx.tap.subscribe {[weak self] _ in
            self?.view.removeFromSuperview()
            deactivateBranc.onNext(true)
        }.disposed(by: self.disposeBag)
        
    }
    
    func noButtonAction() {
        nobutton.rx.tap.subscribe {[weak self] _ in
            self?.view.removeFromSuperview()
            deactivateBranc.onNext(false)
         
        }.disposed(by: self.disposeBag)
        
    }

}
