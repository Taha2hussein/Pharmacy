//
//  FilesCollectionViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 12/03/2022.
//

import UIKit
import SDWebImage
class FilesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var medicineButtonImage: UIButton!
    @IBOutlet weak var fileImageView: UIImageView!
    func setImage(image:PharmacyOrderFile? ) {
        
        if let url = URL(string: baseURLImage + (image?.filePath ?? "")) {
//            self.fileImageView.load(url: url)
            self.fileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar"))
            self.medicineButtonImage.sd_setImage(with: url, for: .normal, placeholderImage: UIImage(named: "avatar"))

        }
    }
}
