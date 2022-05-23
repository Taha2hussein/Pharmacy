//
//  BrandsCatogryCollectionViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 15/03/2022.
//

import UIKit
import SDWebImage
class BrandsCatogryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var brandImageView: UIImageView!
    func setDataForBrands(braand: FilterBrandMessage) {
        self.brandLabel.text = braand.companyName
        if let url = URL(string: baseURLImage + (braand.image ?? "")) {
//            self.brandImageView.load(url: url)
            self.brandImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar"))

        }
    }
}
