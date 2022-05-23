//
//  FilesCollectionViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 12/03/2022.
//

import UIKit

class FilesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var fileImageView: UIImageView!
    func setImage(image:PharmacyOrderFile? ) {
        if let url = URL(string: baseURLImage + (image?.filePath ?? "")) {
            self.fileImageView.load(url: url)
        }
    }
}
