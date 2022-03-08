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
    
    private weak var view: ReviewsViewController?
    private var router: ReviewsRouter?
    var allReviews = [ReviewsDetail]()
    var allReviewPublishSubject = PublishSubject<[ReviewsDetail]>()
    func bind(view: ReviewsViewController, router: ReviewsRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
}

extension ReviewsViewModel {
    
    func intializeData() {
        if let allReviews = allReviews as? [ReviewsDetail] {
            self.allReviewPublishSubject.onNext(allReviews)
            
            
        }
    }
}
