//
//  FindAlternativeTableViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 13/03/2022.
//

import UIKit
import RxCocoa
import RxSwift
import SDWebImage
class FindAlternativeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var removeMedicine: UIButton!
    @IBOutlet weak var addMedicinButton: UIButton!
    @IBOutlet weak var medicinType: UILabel!
    @IBOutlet weak var medicinName: UILabel!
    @IBOutlet weak var medicinImage: UIImageView!
    
    var bag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
        self.removeMedicine.isHidden = true
        self.addMedicinButton.isHidden = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        //                removeMedicine.isHidden = true
        //                addMedicinButton.isHidden = false
    }
    
    func setData(medicine: Medicine) {
        self.medicinType.text = (medicine.medicineForm ?? "") + "-" + (medicine.medicineStrenght ?? "")
        self.medicinName.text = medicine.nameLocalized
        if let url = URL(string: baseURLImage + (medicine.medicineImagePath ?? "")) {
            //            self.medicinImage.load(url: url)
            self.medicinImage.sd_setImage(with: url, placeholderImage: UIImage(named: "Group 3071"))
            
        }
    }
    
    func setDateForSelectedMedicineForRXImage(medicine: Medicine, selectedMedicine:[Medicine],index:Int) {
        
        self.medicinType.text = (medicine.medicineForm ?? "") + "-" + (medicine.medicineStrenght ?? "")
        self.medicinName.text = medicine.nameLocalized
        if let url = URL(string: baseURLImage + (medicine.medicineImagePath ?? "")) {
            //            self.medicinImage.load(url: url)
            self.medicinImage.sd_setImage(with: url, placeholderImage: UIImage(named: "Group 3071"))
            
        }
        guard selectedMedicine.count > 0 else{return}
  
        if selectedMedicine.contains(where: {$0.medicationID == medicine.medicationID}) {
            self.removeMedicine.isHidden = false
            self.addMedicinButton.isHidden = true
           }
        else {
            self.removeMedicine.isHidden = true
            self.addMedicinButton.isHidden = false
           }
        }
    }
