//
//  UperViewModel.swift
//  Pharmacy
//
//  Created by A on 26/01/2022.
//


import Foundation
import RxSwift
import RxCocoa
import RxRelay

class UperViewModel{
    
    private weak var view: UperViewController?
    private var router: UperRouter?
    
    func bind(view: UperViewController, router: UperRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}
