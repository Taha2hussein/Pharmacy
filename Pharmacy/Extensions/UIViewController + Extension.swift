//
//  UIViewController + Extension.swift
//  Pharmacy
//
//  Created by A on 26/01/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func embedd(into controller:UIViewController, childController:UIViewController, containerView: UIView) {
        controller.children.forEach{$0.removeFromParent()}
        containerView.subviews.forEach{$0.removeFromSuperview()}
        
        controller.addChild(childController)
        childController.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
        containerView.addSubview(childController.view)
        childController.didMove(toParent: controller)
//        childController.didMove(toParent: controller)
    }
    
      func removeChild() {
        self.children.forEach {
          $0.willMove(toParent: nil)
          $0.view.removeFromSuperview()
          $0.removeFromParent()
        }
      }
}
