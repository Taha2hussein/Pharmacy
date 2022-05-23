////
////  KeyBoard.swift
////  RxSwiftTraining
////
////  Created by A on 14/12/2021.
////
//
//import Foundation
//import UIKit
//import RxKeyboard
//import RxSwift
//
//class KeyboardViewController : UIViewController {
//
//    var disposeBag = DisposeBag()
//    let tap = UITapGestureRecognizer()
//
//    override func viewDidLoad() {
//
//    }
//
//    func keyBoard(withPush:Bool = true) {
//
//        RxKeyboard.instance.visibleHeight.drive(onNext: { (height) in
//            if withPush {
//                self.view.frame.origin.y = -1 * height
//            }
//        }).disposed(by: disposeBag)
//
//        self.view.addGestureRecognizer(tap)
//        self.tap.cancelsTouchesInView = false
//
//        tap.rx.event.subscribe(onNext: { (tap) in
//            self.view.endEditing(true)
//        }).disposed(by: disposeBag)
//    }
//
//}
