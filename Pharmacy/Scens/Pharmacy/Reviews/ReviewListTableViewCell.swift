//
//  ReviewListTableViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 06/05/2022.
//

import UIKit
import SDWebImage
class ReviewListTableViewCell: UITableViewCell {

    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var replayDesc: UILabel!
    @IBOutlet weak var replayDate: UILabel!
    @IBOutlet weak var replayName: UILabel!
    @IBOutlet weak var replayImage: UIImageView!
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var totalViewHeigh: NSLayoutConstraint!
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var reviewDesc: UILabel!
    @IBOutlet weak var reviewDate: UILabel!
    @IBOutlet weak var reviewName: UILabel!
    @IBOutlet weak var reviewImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setReview(review:ReviewList) {
        self.reviewName.text = review.patientName
        self.reviewDate.text = review.reviewDate
        self.reviewDesc.text = review.notes
        self.replayName.text = review.patientName
        self.replayDate.text = review.replyDate
        self.replayDesc.text = review.reply
        if let url = URL(string: baseURLImage + (review.patientImage ?? "")) {
//            self.reviewImage.load(url: url)
            self.reviewImage.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar"))

        }
        
        if review.reply == nil {
            self.replyView.isHidden = true
            self.totalViewHeigh.constant = 95
            self.replayButton.isHidden = false
        }
        else {
            self.replyView.isHidden = false
            self.replayButton.isHidden = true
            self.totalViewHeigh.constant = 195
           
        }
    }
}
