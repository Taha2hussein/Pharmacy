//
//  EditProfileTableViewCell.swift
//  Pharmacy
//
//  Created by A on 30/01/2022.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var pharmacyCity: UILabel!
    @IBOutlet weak var pharmacyName: UILabel!
    @IBOutlet weak var pharmacyLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(product: PfofileBranch) {
        self.pharmacyName.text = product.branchName
        self.pharmacyCity.text = " (" + (product.cityName ?? "") + ")"
        self.pharmacyLocation.text = product.address

    }
}
