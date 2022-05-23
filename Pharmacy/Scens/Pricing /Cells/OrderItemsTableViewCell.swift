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
    @IBOutlet weak var medicineAlternativeStackView: UIStackView!
    
    ////group3020
    //ellipse138
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
        if orderItem.isAlternative == true {
            self.orderItemLabel.textColor = .orange
            self.orderPrice.textColor = .orange
            self.orderQuanity.textColor = .orange
            self.orderItemsSlectionButton.isHidden = false
            self.medicineAlternativeStackView.isHidden = false
            self.orderItemsSlectionButton.setImage(UIImage(named: "group3020"), for: .normal)
        }
        else if orderItem.isAlternative == false{
            self.orderItemLabel.textColor = .gray
            self.orderPrice.textColor = .gray
            self.orderQuanity.textColor = .gray
            self.orderItemsSlectionButton.isHidden = true
            self.medicineAlternativeStackView.isHidden = true
            self.orderItemsSlectionButton.setImage(UIImage(named: "ellipse138"), for: .normal)
        }
        else {
            self.orderItemsSlectionButton.setImage(UIImage(named: "group3020"), for: .normal)
            self.orderItemLabel.textColor = .blue
            self.orderPrice.textColor = .blue
            self.orderQuanity.textColor = .blue
            self.orderItemsSlectionButton.isHidden = false
            self.medicineAlternativeStackView.isHidden = false

        }

    }
}
