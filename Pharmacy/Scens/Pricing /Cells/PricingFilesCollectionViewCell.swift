//
//  PricingFilesCollectionViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 12/03/2022.
//

import UIKit

class PricingFilesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pricingFile: UIImageView!
    func setImage(image: String?) {
        if let url = URL(string: baseURLImage + (image ?? "")) {
            self.pricingFile.load(url: url)
        }
    }
}
