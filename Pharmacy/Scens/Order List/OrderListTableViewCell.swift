//
//  OrderListTableViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 08/03/2022.
//

import UIKit
import SDWebImage
class OrderListTableViewCell: UITableViewCell {

    @IBOutlet weak var totalLabel: UILabel!
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

    override func prepareForReuse() {
        super.prepareForReuse()
        orderBackGround.backgroundColor = .blue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUPOrders(order:OrderListMessage) {
        self.totalLabel.text = (order.orderTotalFees == 0.0) ? (LocalizedStrings().notPriced)  : "\(order.orderTotalFees ?? 0.0)"
        self.orderNumber.text = order.orderNo
        self.orderCount.text = "\(order.itemCount ?? 0)" + " items"
        if let convertedDate = convertDateFormat(inputDate: order.orderDate ?? "")as? String {
        self.orderDate.text = convertedDate
        }
        self.orderTime.text = order.orderPickingUpTime
        self.orderProvider.text = order.patientName
        self.orderStatus.text = order.orderStatusLocalized
        if let url = URL(string: baseURLImage + (order.patientProfileImage ?? "")) {
//            self.avatar.load(url: url)
            self.avatar.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar"))

        }
        changeOrderBackground(singleOrder: order.singleOrderStatus ?? 0)
        
       
    }


func changeOrderBackground(singleOrder: Int) {
    
    if singleOrder == 0 {
        orderBackGround.backgroundColor = .blue
        orderStatus.textColor = .blue
    }
   else if singleOrder == 4 {
       orderBackGround.backgroundColor = .purple.withAlphaComponent(0.5)
       orderStatus.textColor = .purple.withAlphaComponent(0.5)
    }
    else if singleOrder == 1 {
        orderBackGround.backgroundColor = .purple.withAlphaComponent(0.5)
        orderStatus.textColor = .purple.withAlphaComponent(0.5)
    }
    
    else if singleOrder == 3 {
        orderBackGround.backgroundColor = .orange
        orderStatus.textColor = .orange
    }
    else if singleOrder == 5 {
        orderBackGround.backgroundColor = .green
        orderStatus.textColor = .green
    }
    else if singleOrder == 12 {
        orderBackGround.backgroundColor = .red
        orderStatus.textColor = .red
    }
  }
}
