//
//  BlogTableViewCell.swift
//  Pharmacy
//
//  Created by A on 03/02/2022.
//

import UIKit

class BlogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var blogAvatar: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shateButton: UIButton!
    @IBOutlet weak var blogDate: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var blogDescrbtion: UILabel!
    @IBOutlet weak var blogImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        //set cell to initial state here
        //set like button to initial state - title, font, color, etc.
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData( product: BlogMessage) {
        let pwnerName = LocalStorage().getownerFirstName()
        self.ownerName.text = "Dr. " + pwnerName
        self.blogDescrbtion.text = product.blogTitle
        self.blogDate.text = product.createDate
        if (product.amILiked ?? true) {
            self.likeButton.setImage(UIImage(named:"avatar"), for: .normal)
        } else {
            self.likeButton.setImage(UIImage(named:"like"), for: .normal)
        }

        if let url = URL(string: baseURLImage + (product.blogFilePath ?? "")) {
            self.blogImageView.load(url: url)
        }
    }
    
}
