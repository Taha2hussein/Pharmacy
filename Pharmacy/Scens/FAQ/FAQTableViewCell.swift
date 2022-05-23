//
//  FAQTableViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 15/05/2022.
//

import UIKit

class FAQTableViewCell: UITableViewCell {

    @IBOutlet weak var faqDescribtion: UILabel!
    @IBOutlet weak var faqTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func intializeLabelHeigh(){
        faqTitle.sizeToFit()
        faqDescribtion.sizeToFit()
    }
    
    func setData(FAQ:FAQMessage) {
        let language = getCurrentLanguage()
        intializeLabelHeigh()
        if language == "2"{
        self.faqTitle.text = FAQ.helpsupportNameEn
        self.faqDescribtion.text = FAQ.helpsupportAnswerEn

        }
        else {
            self.faqTitle.text = FAQ.helpsupportNameAr
            self.faqDescribtion.text = FAQ.helpsupportAnswerAr
        }
    }

}
