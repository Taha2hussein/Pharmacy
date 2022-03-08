//
//  UIViewController + Extension.swift
//  Pharmacy
//
//  Created by A on 26/01/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func embed(_ viewController:UIViewController, inParent controller:UIViewController, inView view:UIView){
       viewController.willMove(toParent: controller)
       viewController.view.frame = view.bounds
       view.addSubview(viewController.view)
       controller.addChild(viewController)
       viewController.didMove(toParent: controller)
    }
    
      func removeChild() {
        self.children.forEach {
          $0.willMove(toParent: nil)
          $0.view.removeFromSuperview()
          $0.removeFromParent()
        }
      }
}
