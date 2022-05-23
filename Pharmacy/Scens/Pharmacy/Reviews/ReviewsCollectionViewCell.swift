//
//  ReviewsCollectionViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 06/05/2022.
//

import UIKit

class ReviewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var rateDesc: UILabel!
    @IBOutlet weak var rateView: StarRatingView!
    @IBOutlet weak var rateLabel: UILabel!
    func setReview(review:RateDetail) {
        self.rateLabel.text = "\(review.rate ?? 0)"
        self.rateDesc.text = review.evaluationTypeLocalized
        self.rateView.rating = Float(review.rate ?? 0)
    }
}
