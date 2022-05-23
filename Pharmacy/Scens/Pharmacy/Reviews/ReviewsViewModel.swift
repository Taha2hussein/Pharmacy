//
//  ReviewsViewModel.swift
//  Pharmacy
//
//  Created by taha hussein on 03/03/2022.
//


import Foundation
import RxSwift
import RxCocoa
import RxRelay

class ReviewsViewModel {
    
    var state = State()
    private weak var view: ReviewsViewController?
    private var router: ReviewsRouter?
//    var allReviews = [RateMessage]()
    var RateInstance = PublishSubject<RateMessage>()
    var allReviewPublishSubject = PublishSubject<[RateDetail]>()
    var allReviewsListPublishSubject = PublishSubject<[ReviewList]>()

    func bind(view: ReviewsViewController, router: ReviewsRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}

extension ReviewsViewModel {
    
    func requestAllReviews() {
        state.isLoading.accept(true)
        var request = URLRequest(url: URL(string: rateApi + "41")!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
     
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                let Rate: RateModel!
                Rate = try decoder.decode(RateModel.self, from: data)
                if Rate.successtate == 200 {
                    DispatchQueue.main.async {
                        guard let rate = Rate else {return}
                        self.allReviewsListPublishSubject.onNext(rate.message?.reviewList ?? [])
                        self.RateInstance.onNext(rate.message!)
                        self.allReviewPublishSubject.onNext(rate.message?.rateDetails ?? [])
                    }
                }
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: Rate.errormessage ?? "An error occured , please try again".localized, viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
        
    }
}
