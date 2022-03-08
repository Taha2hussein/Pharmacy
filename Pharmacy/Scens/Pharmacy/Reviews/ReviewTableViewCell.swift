//
//  ReviewTableViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 03/03/2022.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reviewDescribtion: UILabel!
    @IBOutlet weak var reviewRating: StarRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setReviews(review:ReviewsDetail?) {
        self.reviewDescribtion.text = review?.evaluationTypeLocalized
        self.reviewRating.rating = Float(review?.rate ?? 0)
    }

}
