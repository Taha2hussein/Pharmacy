//
//  UIImageConverted.swift
//  Pharmacy
//
//  Created by A on 17/01/2022.
//

import Foundation
import UIKit
extension UIImage {
    func convertImageToBase64String (img: UIImage) -> String {
        let imageData:NSData = img.jpegData(compressionQuality: 0.50)! as NSData //UIImagePNGRepresentation(img)
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        return imgString
    }
}
