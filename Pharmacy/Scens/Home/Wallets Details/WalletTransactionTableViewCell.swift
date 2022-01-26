//
//  WalletTransactionTableViewCell.swift
//  Pharmacy
//
//  Created by A on 26/01/2022.
//

import UIKit

class WalletTransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var chargeDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
