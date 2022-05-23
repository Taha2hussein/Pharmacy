//
//  PharmacyProfileTableViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 09/02/2022.
//

import UIKit
import RxCocoa
import RxSwift
import SDWebImage
class PharmacyProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var branchMenuView: UIView!
    @IBOutlet weak var branchMenuEditButton: UIButton!
    @IBOutlet weak var branchMenuDeleteButton: UIButton!
    @IBOutlet weak var branchMenuCloseButton: UIButton!
    
    @IBOutlet weak var pharmacistMenuView: UIView!
    
    @IBOutlet weak var pharmacistActivationButton: UIButton!
    @IBOutlet weak var pharmacistMenuEdit: UIButton!
    @IBOutlet weak var pharmacistMenuCDeactivate: UIButton!
    @IBOutlet weak var pharmacistMenuClose: UIButton!
    
    @IBOutlet weak var branchActiveView: UIView!
    @IBOutlet weak var branchActiveButton: UIButton!
    @IBOutlet weak var branchView: UIView!
    @IBOutlet weak var branhcMenu: UIButton!
    @IBOutlet weak var pharmacyDetails: UILabel!
    @IBOutlet weak var pharmacyLocation: UILabel!
    @IBOutlet weak var pharmacyName: UILabel!
    
    
    @IBOutlet weak var pharmacistActiveView: UIView!
    @IBOutlet weak var pharmacistMenu: UIButton!
    @IBOutlet weak var pharmacistPhone: UILabel!
    @IBOutlet weak var phrmacistEmail: UILabel!
    @IBOutlet weak var pharmcistJob: UILabel!
    @IBOutlet weak var pharmacistName: UILabel!
    @IBOutlet weak var phramcistImaeg: UIImageView!
    @IBOutlet weak var pharmcistView: UIView!
    
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
        self.branchMenuView.isHidden = true
        bag = DisposeBag()
        branchMenuView.isHidden = true
        pharmacistMenuView.isHidden = true
    }
    
    func setDataForPharmacist(pharmacist: EmployeesList) {
        if pharmacist.isActive == true {
            self.pharmacistActiveView.backgroundColor = .green
        }
        else {
            self.pharmacistActiveView.backgroundColor = .red
        }
        self.pharmacistName.text = pharmacist.employeeName
        self.pharmcistJob.text = pharmacist.employeeType
        self.phrmacistEmail.text = pharmacist.employeeEmail
        self.pharmacistPhone.text = pharmacist.mobileNumber
        if pharmacist.isActive == false {
            self.pharmcistView.backgroundColor = .gray
            pharmacistActivationButton.isHidden = false
        }
        else{
            pharmacistActivationButton.isHidden = true
            self.pharmcistView.backgroundColor = .white

        }
        if let url = URL(string: baseURLImage + (pharmacist.image ?? "")) {
//            self.phramcistImaeg.load(url: url)
            self.phramcistImaeg.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar"))

        }
    }
    

    func setData( product:BranchesList) {
        if product.isActive == true {
            self.branchActiveView.backgroundColor = .green
        }
        else {
            self.branchActiveView.backgroundColor = .red
        }
        self.pharmacyName.text = product.branchName
        self.pharmacyLocation.text = "( \(product.cityName ?? "") )"
        self.pharmacyDetails.text = product.address
        if product.isActive == false {
            self.branchView.backgroundColor = .gray
            branchActiveButton.isHidden = false
        }
        else{
            branchActiveButton.isHidden = true
            self.branchView.backgroundColor = .white

        }
    }
}
