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
    
    @IBOutlet weak var reviewTableView: UITableView!
    
    var articleDetailsViewModel = ReviewsViewModel()
    private var router = ReviewsRouter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindPharmacistToTableView()
        bindViewControllerRouter()
        backTapped()
        articleDetailsViewModel.intializeData()
    }
    
    func setup() {
        self.reviewTableView.rowHeight = 120
    }
    
    func bindPharmacistToTableView() {
        articleDetailsViewModel.allReviewPublishSubject
            .bind(to: self.reviewTableView
                    .rx
                    .items(cellIdentifier: String(describing:  ReviewTableViewCell.self),
                           cellType: ReviewTableViewCell.self)) { row, model, cell in
              
                cell.setReviews(review: model)
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
