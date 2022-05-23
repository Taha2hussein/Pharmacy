//
//  OrderTrackingPrcingTableViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 17/03/2022.
//

import UIKit

class OrderTrackingPrcingTableViewCell: UITableViewCell {
    @IBOutlet weak var medicinLabel: UILabel!
    @IBOutlet weak var prderPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

    func setData(orderItem:Orderitem?) {
        let orderPrice = orderItem?.itemFees ?? 0
     
        self.medicinLabel.text = "\(orderItem?.quantity ?? 0)" + "x  " + (orderItem?.medicationnameLocalized ?? "")
//        if orderItem?.isAlternative == true {
//            self.medicinLabel.textColor = .orange
//            self.prderPrice.textColor = .orange
//
//        }
//        else if  orderItem?.isAlternative == false{
//            self.medicinLabel.textColor = .gray
//            self.prderPrice.textColor = .gray
//
//        }
//        else {
//            self.medicinLabel.textColor = .blue
//            self.prderPrice.textColor = .blue
//
//
//        }
//
        self.medicinLabel.textColor = .gray
        if orderPrice > 0 {
        self.prderPrice.text = "\(orderPrice)"
            self.prderPrice.textColor = .gray
        }
        else {
            self.prderPrice.text = LocalizedStrings().unavialble
            self.prderPrice.textColor = .red
        }

    }
}
