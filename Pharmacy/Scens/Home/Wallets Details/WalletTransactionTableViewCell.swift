//
//  WalletTransactionTableViewCell.swift
//  Pharmacy
//
//  Created by A on 26/01/2022.
//

import UIKit

enum transactionSegmentSelected {
    case all
    case received
    case used
}

class WalletTransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var chargeDate: UILabel!
    @IBOutlet weak var orderName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.balanceLabel.text = ""
        self.valueLabel.text = ""
        self.chargeDate.text = ""

        //set cell to initial state here
        //set like button to initial state - title, font, color, etc.
    }
    
    func setData( product: walletTransactionMessage, selected: transactionSegmentSelected) {
        switch selected {
            
        case .all:
            self.balanceLabel.text = "\(Int(product.balanceAfter ?? 0.0))" + " EGP".localized
            self.valueLabel.text = "\(product.amount ?? 0.0)" + " EGP".localized
            self.chargeDate.text = product.transactionDate
            self.orderName.text = product.orderNum
        case.received:
            if product.factor == 1 {
                self.balanceLabel.text = "\(Int(product.balanceAfter ?? 0.0))" + " EGP".localized
                self.valueLabel.text = "\(product.amount ?? 0.0)" + " EGP".localized
                self.chargeDate.text = product.transactionDate
                self.orderName.text = product.orderNum
            }
            else {
                self.containerView.isHidden = true
                self.heightConstraint.constant = 0.0
                self.orderName.text = product.orderNum
            }
            
        case .used:
            if product.factor == -1 {
                self.balanceLabel.text = "\(Int(product.balanceAfter ?? 0.0))" + " EGP".localized
                self.valueLabel.text = "\(product.amount ?? 0.0)"
                self.chargeDate.text = product.transactionDate
                self.orderName.text = product.orderNum
            }
            else {
                self.containerView.isHidden = true
                self.heightConstraint.constant = 0.0
                self.orderName.text = product.orderNum
            }
            
        }
        
     
    }
}
