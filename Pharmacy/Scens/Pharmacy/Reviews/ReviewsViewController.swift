//
//  ReviewsViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 03/03/2022.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class ReviewsViewController: BaseViewController {
    
    @IBOutlet weak var backButtonAction: UIButton!
    
    @IBOutlet weak var reviewListTableView: UITableView!
    @IBOutlet weak var rateView: StarRatingView!
    @IBOutlet weak var totalRate: UILabel!
    @IBOutlet weak var reviewCollectionView: UICollectionView!
    
    var articleDetailsViewModel = ReviewsViewModel()
    private var router = ReviewsRouter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindPharmacistToTableView()
        bindViewControllerRouter()
        backTapped()
        bindRate()
        bindReviewList()
        subscribeToLoader()
        articleDetailsViewModel.requestAllReviews()
    }
    
 
    func subscribeToLoader() {
        articleDetailsViewModel.state.isLoading.subscribe(onNext: {[weak self] (isLoading) in
            DispatchQueue.main.async {
                if isLoading {
                    
                    self?.showLoading()
                    
                } else {
                    self?.hideLoading()
                }
            }
        }).disposed(by: self.disposeBag)
    }
    
    func bindReviewList() {
        articleDetailsViewModel.allReviewsListPublishSubject.bind(to: self.reviewListTableView
            .rx
            .items(cellIdentifier: String(describing:  ReviewListTableViewCell.self),
                   cellType: ReviewListTableViewCell.self)) { row, model, cell in
            
            cell.setReview(review: model)
        }.disposed(by: self.disposeBag)
    }
    
    func bindRate() {
        articleDetailsViewModel.RateInstance.subscribe { [weak self] rate in
            if let rate = rate.element {
                self?.totalRate.text = "\(rate.totalRate ?? 0)"
                self?.rateView.rating = Float(rate.totalRate ?? 0)
                
            }
        }.disposed(by: self.disposeBag)
        
    }
    
    func bindPharmacistToTableView() {
        articleDetailsViewModel.allReviewPublishSubject
            .bind(to: self.reviewCollectionView
                .rx
                .items(cellIdentifier: String(describing:  ReviewsCollectionViewCell.self),
                       cellType: ReviewsCollectionViewCell.self)) { row, model, cell in
                
                cell.setReview(review: model)
            }.disposed(by: self.disposeBag)
    }
    
    func backTapped() {
        backButtonAction.rx.tap.subscribe { [weak self] _ in
            self?.router.backView()
        } .disposed(by: self.disposeBag)
        
    }
    
}
extension ReviewsViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
