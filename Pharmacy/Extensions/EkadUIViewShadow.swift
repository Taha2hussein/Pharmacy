//
//  EkadUIViewShadow.swift
//  Pharmacy
//
//  Created by A on 07/01/2022.
//

import Foundation
import UIKit

class PayMobShadowUIView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = false
        layer.shouldRasterize = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.masksToBounds = false
        layer.shouldRasterize = true
    }
    

    @IBInspectable override var shadowRadius:CGFloat {
        get{return 0}
        set{
            self.layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable override var shadowOffset:CGSize {
        get{return CGSize(width: 0, height: 0)}
        set{
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable override var shadowOpacity:Float {
        get{return 0}
        set{
            self.layer.shadowOpacity = newValue
        }
    }
    
//    @IBInspectable var shadowColor:UIColor {
//        get{return .black}
//        set{
//            self.layer.shadowColor = newValue.cgColor
//        }
//    }
    
    
    
    
//    func applyShadow(scale: Bool = true , opacity:Float = 0.2 , width: Int = 3 , height:Int = 3 , radius:CGFloat = 5 , maskToBounds:Bool = false) {
//


//
//        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
//    }
}

