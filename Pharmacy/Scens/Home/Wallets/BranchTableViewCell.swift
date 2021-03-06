//
//  BranchTableViewCell.swift
//  Pharmacy
//
//  Created by A on 25/01/2022.
//

import UIKit

class BranchTableViewCell: UITableViewCell {

    @IBOutlet weak var totalBalance: UILabel!
    @IBOutlet weak var expnseLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var pharmacyName: UILabel!
    @IBOutlet weak var ownerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(product: BrahcnListMessage) {
        self.totalBalance.text = "\(Int(product.totalBalance ?? 0))"
        self.incomeLabel.text = "\(Int(product.totalIncome ?? 0))"
        self.expnseLabel.text = "\(Int(product.totalExpense ?? 0))"
        self.pharmacyName.text =  product.entityNameLocalized
//        self.ownerImage.text = "\(Int(product?.totalExpense ?? 0))"
    }

}
