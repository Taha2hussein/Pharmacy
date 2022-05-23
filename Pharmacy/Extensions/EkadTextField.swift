//
//  EkadTextField.swift
//  Pharmacy
//
//  Created by A on 07/01/2022.
//

import Foundation
import UIKit

extension UITextField {
    @IBInspectable var IsPrimaryColor:Bool {
        get{return true}
        set{
            if newValue{
                self.textColor = Assets.Primary
            }else{
                self.textColor = Assets.Secondary
            }

        }
    }

    @IBInspectable var Translationkey:String {
        get{return ""}
        set{
            self.placeholder = NSLocalizedString(newValue, comment: "")
        }
    }

//    @IBInspectable var isBold:Bool {
//        get{return false}
//        set{
//            self.fontStyle(isBold: newValue)
//        }
//    }
//
//
//    func fontStyle(isBold: Bool = false, with size:CGFloat = PAYMOB_FONTS().FONT_SIZE_NORMAL){
//        if isBold {
//            self.font = UIFont(name: PAYMOB_FONTS().BOLD_FONT_NAME, size:size)
//        } else {
//            self.font = UIFont(name: PAYMOB_FONTS().FONT_NAME, size:size)
//        }
//    }
}

extension UITextView{
    @IBInspectable var IsPrimaryColor:Bool {
        get{return true}
        set{
            if newValue{
                self.textColor = Assets.Primary
            }else{
                self.textColor = Assets.Secondary
            }

        }
    }
    
    @IBInspectable var Translationkey:String {
        get{return ""}
        set{
            self.placeholder = NSLocalizedString(newValue, comment: "")
        }
    }

//    @IBInspectable var isBold:Bool {
//        get{return false}
//        set{
//            self.fontStyle(isBold: newValue)
//        }
//    }

    @IBInspectable var BottomBorder:Bool {
        get{return true}
        set{
            DispatchQueue.main.async {
                self.addBottomBorder()
            }
        }
    }

    func addBottomBorder() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = Assets.appDarkGray.cgColor
//        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }

//    func fontStyle(isBold: Bool = false, with size:CGFloat = PAYMOB_FONTS().FONT_SIZE_NORMAL){
//        if isBold {
//            self.font = UIFont(name: PAYMOB_FONTS().BOLD_FONT_NAME, size:size)
//        } else {
//            self.font = UIFont(name: PAYMOB_FONTS().FONT_NAME, size:size)
//        }
//    }
}

