//
//  BranchesPopViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 20/04/2022.
//

import UIKit

class BranchesPopViewCell: UITableViewCell {

    @IBOutlet weak var branchName: UILabel!
    @IBOutlet weak var selectedButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setDate(branches: AllBranchesBranch) {
        self.branchName.text = branches.branchName
    }
}
