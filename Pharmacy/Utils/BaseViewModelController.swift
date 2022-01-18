////
////  BaseViewModelController.swift
////  Kareem
////
////  Created by abedalkareem omreyh on 14/12/2019.
////  Copyright © 2019 abedalkareem. All rights reserved.
////
//
//import RxSwift
//import UIKit
//
/////
///// Any `ViewController` need to have a view model it should inherit this
///// class. this class will provid an injected `viewModel`.
/////
///// An example:
///// ```
///// class SplashViewController: BaseViewModelController<SplashViewModel> {
/////   .....
/////   private func observeForItems() {
/////     viewModel.items
/////       .subscribe(onNext: {
/////   .....
///// }
///// ```
/////
//class BaseViewModelController<ViewModel: ViewModelType>: BaseViewController {
//
//  // MARK: - Properties
//
//   var viewModel: ViewModel
//
//  var disposeBag = DisposeBag()
//
//  // MARK: Private properties
//
//  // MARK: - ViewController lifecycle
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//  }
//
//
//
//
//}
