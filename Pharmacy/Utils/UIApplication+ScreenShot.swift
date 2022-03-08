//
//  UIApplication+ScreenShot.swift
//  BeyondTask
//
//  Created by A on 30/12/2021.
//

import UIKit
extension UIImage {

    convenience init?(view: UIView?) {
        guard let view: UIView = view else { return nil }

        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }

        view.layer.render(in: context)
        let contextImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard
            let image: UIImage = contextImage,
            let pngData: Data = image.pngData()
            else { return nil }

        self.init(data: pngData)
    }

}
