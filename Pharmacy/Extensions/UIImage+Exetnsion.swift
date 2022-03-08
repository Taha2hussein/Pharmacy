//
//  UIImage+Exetnsion.swift
//  RawajTest
//
//  Created by A on 01/01/2022.
//

import UIKit
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
