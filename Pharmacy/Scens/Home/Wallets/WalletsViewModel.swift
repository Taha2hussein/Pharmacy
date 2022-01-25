//
//  WalletsViewModel.swift
//  Pharmacy
//
//  Created by A on 20/01/2022.
//
import Foundation
import RxSwift
import RxCocoa
import RxRelay

class WalletsViewModel{
    
    private weak var view: WalletsViewController?
    private var router: WalletsRouter?
    
    func bind(view: WalletsViewController, router: WalletsRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}
