//
//  PricingFilesCollectionViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 12/03/2022.
//

import UIKit
import SDWebImage
class PricingFilesCollectionViewCell: UICollectionViewCell {
    
    var selectFile : (() -> Void)? = nil
    @IBOutlet weak var pricingFileButton: UIButton!
    @IBOutlet weak var pricingFile: UIImageView!
    func setImage(image: String?) {
        if let url = URL(string: baseURLImage + (image ?? "")) {
//            self.pricingFile.load(url: url)
            self.pricingFile.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar"))
            self.pricingFileButton.sd_setImage(with: url, for: .normal, placeholderImage: UIImage(named: "avatar"))

        }
    }
    
    @IBAction func pricingFileTapped(_ sender: Any) {
        selectFile?()
    }
    
}
