////
////  UITextView+Extension.swift
////  Pharmacy
////
////  Created by taha hussein on 26/03/2022.
////
//
//import Foundation
//import UIKit
//@IBDesignable
//class PlaceHolderTextView: UITextView {
//
//    @IBInspectable var placeholder: String = "" {
//         didSet{
//             updatePlaceHolder()
//        }
//    }
//
//    @IBInspectable var placeholderColor: UIColor = UIColor.gray {
//        didSet {
//            updatePlaceHolder()
//        }
//    }
//
//    private var originalTextColor = UIColor.darkText
//    private var originalText: String = ""
//
//    private func updatePlaceHolder() {
//
//        if self.text == "" || self.text == placeholder  {
//
//            self.text = placeholder
//            self.textColor = placeholderColor
//            if let color = self.textColor {
//
//                self.originalTextColor = color
//            }
//            self.originalText = ""
//        } else {
//            self.textColor = self.originalTextColor
//            self.originalText = self.text
//        }
//
//    }
//
//    override func becomeFirstResponder() -> Bool {
//        let result = super.becomeFirstResponder()
//        self.text = self.originalText
//        self.textColor = self.originalTextColor
//        return result
//    }
//    override func resignFirstResponder() -> Bool {
//        let result = super.resignFirstResponder()
//        updatePlaceHolder()
//
//        return result
//    }
//}

import UIKit
extension UIColor {
    var hexString: String {
        let components = cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)),
                               lroundf(Float(b * 255)))

        return hexString
    }
}
extension String {
    func htmlAttributed(family: String?, size: CGFloat, color: UIColor) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(size)pt !important;" +
                "color: #\(color.hexString) !important;" +
                "font-family: \(family ?? "Helvetica"), Helvetica !important;" +
            "}</style> \(self)"

            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }

            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}
