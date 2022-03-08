//
//  EkadLabel.swift
//  Pharmacy
//
//  Created by A on 07/01/2022.
//

import Foundation
import UIKit

extension UILabel {
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
            self.text = NSLocalizedString(newValue, comment: "")
        }
    }
    
    @IBInspectable var IsUpperCased:Bool {
        get{return true}
        set{
            self.text = self.text?.uppercased()
        }
    }
    
//    @IBInspectable var isBold:Bool {
//        get{return false}
//        set{
//            self.fontStyle(isBold: newValue)
//        }
//    }
//
//    func fontStyle(isBold: Bool = false, with size:CGFloat = PAYMOB_FONTS().FONT_SIZE_NORMAL){
//        if isBold {
//            self.font = UIFont(name: PAYMOB_FONTS().BOLD_FONT_NAME, size:size)
//        } else {
//            self.font = UIFont(name: PAYMOB_FONTS().FONT_NAME, size:size)
//        }
//    }
//
//    func fontStyle() {
//        self.font = UIFont(name: PAYMOB_FONTS().FONT_NAME, size: self.font.pointSize)
//    }
}




enum Color{
    case PRIMARYCOLOR , SECONDARYCOLOR
    func value()->UIColor{
        switch self {
        case .PRIMARYCOLOR:
            return Assets.Primary
        case .SECONDARYCOLOR:
        return Assets.Secondary
        }
    }
}
