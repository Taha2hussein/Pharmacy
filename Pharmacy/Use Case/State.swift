//
//  State.swift
//  RxSwiftTraining
//
//  Created by A on 07/12/2021.
//

import Foundation
import RxSwift
import RxRelay

class State {
    var isLoading = BehaviorRelay<Bool>(value: false)
    var isProductTableViewHide = BehaviorRelay<Bool>(value:false)
}

