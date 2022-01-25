//
//  DashboardViewModel.swift
//  Pharmacy
//
//  Created by A on 20/01/2022.
//

import Foundation
import Foundation
import RxSwift
import RxCocoa
import RxRelay

class DashboardViewModel{
    
    private weak var view: DashboardViewController?
    private var router: DashboardRouter?
    var dashBoard = PublishSubject<DashboardModel>()
    var state = State()

    func bind(view: DashboardViewController, router: DashboardRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func getDashboard() {
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: dashboardApi)!)
        request.httpMethod = "GET"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                let decoder = JSONDecoder()
                var DashboardElement = DashboardModel()
                 DashboardElement = try decoder.decode(DashboardModel.self, from: data)
                if DashboardElement.successtate == 200 {
                    self.dashBoard.onNext(DashboardElement)
                    }
//                
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
