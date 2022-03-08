//
//  CheckInternet.swift
//  RxSwiftTraining
//
//  Created by A on 14/12/2021.
//

import UIKit
import RxReachability
import RxCocoa
import RxSwift
import Reachability
import RxKeyboard

class CheckInternetViewController: KeyboardViewController {
    
    let reachability: Reachability! = try? Reachability()
   var alertError = Alert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //      reachability.rx.isReachable
        //          .map { "Is reachable: \($0)" }
        ////          .bind(to: label.rx.text)
        //          .disposed(by: disposeBag)
        
        bindReachability()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? reachability?.startNotifier()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability?.stopNotifier()
    }
}

extension CheckInternetViewController {
    
    func bindReachability() {
        
        reachability?.rx.reachabilityChanged
            .subscribe(onNext: { _ in
                //        print("Reachability changed: \(Reachability.currentReachabilityStatus)")
            })
            .disposed(by: disposeBag)
        
        reachability?.rx.status
            .subscribe(onNext: { _ in
                //        print("Reachability status changed: \(Reachability)")
            })
            .disposed(by: disposeBag)
        
        reachability?.rx.isReachable
            .subscribe(onNext: { isReachable in
                if isReachable == false {
                    self.alertError.displayError(text: "No network found...", viewController: self)
                }
            })
            .disposed(by: disposeBag)
        
        reachability?.rx.isConnected
            .subscribe(onNext: {
                //        print("Is connected")
            })
            .disposed(by: disposeBag)
        
        reachability?.rx.isDisconnected
            .subscribe(onNext: {
                //        print("Is disconnected")
            })
            .disposed(by: disposeBag)
    }
}
