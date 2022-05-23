//
//  BranchTableViewCell.swift
//  Pharmacy
//
//  Created by A on 25/01/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
class BranchTableViewCell: UITableViewCell {

    
    @IBOutlet weak var mainBranchLabel: UILabel!
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    func setData(product: BrahcnListMessage) {
        self.totalBalance.text = "\(Int(product.totalBalance ?? 0))" + " EGP".localized
        self.incomeLabel.text = "\(Int(product.totalIncome ?? 0))"
        self.expnseLabel.text = "\(Int(product.totalExpense ?? 0))"
        self.pharmacyName.text =  product.entityNameLocalized
        self.mainBranchLabel.text = product.branchNameLocalized
//        self.ownerImage.text = "\(Int(product?.totalExpense ?? 0))"
    }

}
