//
//  OrderListTableViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 08/03/2022.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {

    @IBOutlet weak var orderBackGround: UIView!
    @IBOutlet weak var orderProvider: UILabel!
    @IBOutlet weak var orderCount: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var orderStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUPOrders(order:OrderListMessage) {
        self.orderNumber.text = order.orderNo
        self.orderCount.text = "\(order.itemCount ?? 0)" + " items"
        self.orderDate.text = order.orderDate
        self.orderTime.text = order.orderPickingUpTime
        self.orderProvider.text = order.patientName
        self.orderStatus.text = order.orderStatusLocalized
        if let url = URL(string: baseURLImage + (order.patientProfileImage ?? "")) {
            self.avatar.load(url: url)
        }
       
    }
}
