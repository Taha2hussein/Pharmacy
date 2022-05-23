//
//  OrderFilterViewModel.swift
//  Pharmacy
//
//  Created by taha hussein on 20/05/2022.
//

import Foundation
import UIKit
import RxRelay
import RxCocoa
import RxSwift

class OrderFilterViewModel{
    
    private weak var view: OrderFilterViewController?
    private var router: OrderFilterRouter?
    var notificationListInstance = BehaviorSubject<[MotificaitonListMessage]>(value:[])
    var state = State()

    func bind(view: OrderFilterViewController, router: OrderFilterRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}
