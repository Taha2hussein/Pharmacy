//
//  FindAlternativeTableViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 13/03/2022.
//

import UIKit

class FindAlternativeTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var addMedicinButton: UIButton!
    @IBOutlet weak var medicinType: UILabel!
    @IBOutlet weak var medicinName: UILabel!
    @IBOutlet weak var medicinImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(medicine: Medicine) {
        self.medicinType.text = medicine.medicineForm
        self.medicinName.text = medicine.nameLocalized
        if let url = URL(string: baseURLImage + (medicine.medicineImagePath ?? "")) {
            self.medicinImage.load(url: url)
        }
    }
}
