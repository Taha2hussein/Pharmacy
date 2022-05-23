
//
//  UIImage+Exetnsion.swift
//  RawajTest
//
//  Created by A on 01/01/2022.
//

import UIKit
import FlagKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

class ImageConvert {
    func convertImageToBase64(image: UIImage) -> String {
        
         let jpegCompressionQuality: CGFloat = 0.9
        let ownerImage = image.jpegData(compressionQuality: jpegCompressionQuality)?.base64EncodedString() ?? "test.png"
        return ownerImage
    }
}

class ImageCountryCode {
    func setCountryCode(countryImage: UIImageView) {
        let countryCode = LocalizedStrings().countryCode
        let flag = Flag(countryCode: countryCode)!
        countryImage.image = flag.originalImage
    }
}
