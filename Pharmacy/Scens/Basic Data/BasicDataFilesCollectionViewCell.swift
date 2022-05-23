//
//  BasicDataFilesCollectionViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 23/04/2022.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import PDFKit
import SDWebImage
class BasicDataFilesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteButtons: UIButton!
    @IBOutlet weak var filesImageView: UIImageView!
    
    var bag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
//        filesImageView.image = nil
    }
    
    func setFile(modle:File) {
        if let url = URL(string: baseURLImage + (modle.filePath ?? "")) {
            self.filesImageView.load(url: url)
//            self.filesImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar"))

        }
    }

    
}
