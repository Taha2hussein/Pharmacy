//
//  EkadButton.swift
//  Pharmacy
//
//  Created by A on 07/01/2022.
//

import Foundation
import UIKit

extension UIButton {
    @IBInspectable var isHavebackGroundColor:Bool {
        get{ return true}
        set{
            if newValue{
                self.backgroundColor = Assets.Primary
            }else{
                self.backgroundColor = UIColor.clear
            }
        }
    }
    @IBInspectable var IsPrimaryColor:Bool {
        get{return true}
        set{
            if newValue{
                self.setTitleColor(Assets.Primary, for: .normal)
            }else{
                self.setTitleColor(Assets.Secondary, for: .normal)
            }
            
        }
    }
    @IBInspectable var Translationkey:String {
        get{return ""}
        set{
            self.setTitle(NSLocalizedString(newValue, comment: ""), for:.normal )
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
//            self.titleLabel?.font = UIFont(name: PAYMOB_FONTS().BOLD_FONT_NAME, size:size)
//        } else {
//            self.titleLabel?.font = UIFont(name: PAYMOB_FONTS().FONT_NAME, size:size)
//        }
//    }
}

