//
//  BrandsCatogryCollectionViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 15/03/2022.
//

import UIKit

class BrandsCatogryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var brandImageView: UIImageView!
    func setDataForBrands(braand: FilterBrandMessage) {
        self.brandLabel.text = braand.companyName
        if let url = URL(string: baseURLImage + (braand.image ?? "")) {
            self.brandImageView.load(url: url)
        }
    }
}
