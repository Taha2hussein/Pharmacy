//
//  BlogTableViewCell.swift
//  Pharmacy
//
//  Created by A on 03/02/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import SDWebImage
class BlogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var unLikeButton: UIButton!
    @IBOutlet weak var blogAvatar: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shateButton: UIButton!
    @IBOutlet weak var blogDate: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var blogDescrbtion: UILabel!
    @IBOutlet weak var blogImageView: UIImageView!
    
    var  bag = DisposeBag()
    

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()

      
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData( product: BlogMessage) {
//        let pwnerName = LocalStorage().getownerFirstName()
        self.ownerName.text = product.blogTitle
//        self.blogDescrbtion.text = product.blogTitle
        
        if let convertedDate = convertDateFormat(inputDate: product.createDate ?? "")as? String {
            self.blogDate.text = convertedDate
        }
//        self.blogDate.text = product.createDate
        if (product.amILiked ?? true) {
            self.likeButton.setImage(UIImage(named:"like-1"), for: .normal)
            self.unLikeButton.isHidden = true
        } else {
            self.likeButton.isHidden = true
            self.unLikeButton.setImage(UIImage(named:"like"), for: .normal)
        }

        if let url = URL(string: baseURLImage + (product.blogFilePath?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")) {
//            self.blogImageView.load(url: url)
            self.blogImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "like-1"))

        }
    }
    
}
