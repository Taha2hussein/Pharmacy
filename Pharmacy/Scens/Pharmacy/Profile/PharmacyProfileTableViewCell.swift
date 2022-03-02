//
//  PharmacyProfileTableViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 09/02/2022.
//

import UIKit

class PharmacyProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var branchView: UIView!
    @IBOutlet weak var pharmaycMenu: UIButton!
    @IBOutlet weak var pharmacyDetails: UILabel!
    @IBOutlet weak var pharmacyLocation: UILabel!
    @IBOutlet weak var pharmacyName: UILabel!
    
    @IBOutlet weak var pharmacistPhone: UILabel!
    @IBOutlet weak var phrmacistEmail: UILabel!
    @IBOutlet weak var pharmcistJob: UILabel!
    @IBOutlet weak var pharmacistMenu: UIButton!
    @IBOutlet weak var pharmacistName: UILabel!
    @IBOutlet weak var phramcistImaeg: UIImageView!
    @IBOutlet weak var pharmcistView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setDataForPharmacist(pharmacist: EmployeesList) {
        
        self.pharmacistName.text = pharmacist.employeeName
        self.pharmcistJob.text = pharmacist.employeeType
        self.phrmacistEmail.text = pharmacist.employeeEmail
        self.pharmacistPhone.text = pharmacist.mobileNumber
        if let url = URL(string: baseURLImage + (pharmacist.image ?? "")) {
            self.phramcistImaeg.load(url: url)
        }
    }
    
    func setData( product:BranchesList) {
        self.pharmacyName.text = product.branchName
        self.pharmacyLocation.text = "( \(product.cityName) )"
        self.pharmacyDetails.text = product.address
    }
}
