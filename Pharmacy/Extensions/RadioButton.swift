//
//  RadioButton.swift
//  Pharmacy
//
//  Created by A on 08/01/2022.
//

import Foundation
import UIKit

class RadioButtonController: NSObject {
    var buttonsArray: [UIButton]! {
        didSet {
            for b in buttonsArray {
                b.setImage(UIImage(named: "ellipse138"), for: .normal)
                b.setImage(UIImage(named: "group3020"), for: .selected)
            }
        }
    }
    var selectedButton: UIButton?
    var defaultButton: UIButton = UIButton() {
        didSet {
            buttonArrayUpdated(buttonSelected: self.defaultButton)
        }
    }

    func buttonArrayUpdated(buttonSelected: UIButton) {
        for b in buttonsArray {
            if b == buttonSelected {
                selectedButton = b
                b.isSelected = true
            } else {
                b.isSelected = false
            }
        }
    }
}

//
//import UIKit
//
//class CheckoutVC: UIViewController {
//
//    @IBOutlet weak var btnPaytm: UIButton!
//    @IBOutlet weak var btnOnline: UIButton!
//    @IBOutlet weak var btnCOD: UIButton!
//
//    let radioController: RadioButtonController = RadioButtonController()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        radioController.buttonsArray = [btnPaytm,btnCOD,btnOnline]
//        radioController.defaultButton = btnPaytm
//    }
//
//    @IBAction func btnPaytmAction(_ sender: UIButton) {
//        radioController.buttonArrayUpdated(buttonSelected: sender)
//    }
//
//    @IBAction func btnOnlineAction(_ sender: UIButton) {
//        radioController.buttonArrayUpdated(buttonSelected: sender)
//    }
//
//    @IBAction func btnCodAction(_ sender: UIButton) {
//        radioController.buttonArrayUpdated(buttonSelected: sender)
//    }
//}
