//
//  OrderItemsTableViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 13/03/2022.
//

import UIKit
import RxRelay
import RxSwift
class OrderItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var orderItemLabel: UILabel!
    @IBOutlet weak var medicinAlternativ: UIButton!
    @IBOutlet weak var orderPrice: UITextField!
    @IBOutlet weak var orderQuanity: UITextField!
    @IBOutlet weak var orderItemsSlectionButton: UIButton!
    
    var bag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
//        totalOrderItemsPrice.onNext(0)
    }
    
    func setOrderItems(orderItem: OrderTrackingPharmacyOrderItem) {
        self.orderQuanity.text = orderItem.amountDetailsLocalized
        self.orderPrice.text = "\(orderItem.itemFees ?? 0)"
        self.orderQuanity.text = "\(orderItem.quantity ?? 0)"
        self.orderItemLabel.text = "\(orderItem.quantity ?? 0)" + "x  " + (orderItem.medicationNameLocalized ?? "")
//        orderOrice = Int(orderItem.itemFees ?? 0)
//        totalOrderItemsPrice.onNext(orderOrice)

    }
}
