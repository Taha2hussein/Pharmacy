//
//  OrderInvoiceTableViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 13/03/2022.
//

import UIKit
import RxRelay
import RxSwift
class OrderInvoiceTableViewCell: UITableViewCell {

    @IBOutlet weak var orderInvoiceName: UILabel!
    @IBOutlet weak var invoiceOrderAlternative: UIButton!
    @IBOutlet weak var invoiceOrderDeletion: UIButton!
    @IBOutlet weak var invoiceOrderPrice: UITextField!
    @IBOutlet weak var invoiceOrderQuantity: UITextField!
    
    var changePriceCompletionHandler:((_ price:Double)->Void)?
    var changeQuantityCompletionHandler:((_ price:Int)->Void)?

    var bag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func changeQuantityAction(_ sender: UITextField) {
        if let quantity = Int(sender.text ?? "0") {
        changeQuantityCompletionHandler?(quantity)
        }
    }
    
    @IBAction func changePriceAction(_ sender: UITextField) {
        print("dddd")
        if let priceInDouble = Double(sender.text ?? "0.0") {
        changePriceCompletionHandler?(priceInDouble)
        }
        
    }
    
    func setData(orderInvoice: Medicine?) {
//        self.invoiceOrderQuantity.text = orderInvoice?.medicineAmountDetailsLocalized
        self.invoiceOrderPrice.text = "\(orderInvoice?.price ?? 0)"
        self.invoiceOrderQuantity.text = orderInvoice?.medicineAmountDetailsLocalizeds
        self.orderInvoiceName.text = "1x  " + (orderInvoice?.nameLocalized ?? "")
        if self.invoiceOrderPrice.text == "0.0" {
            self.invoiceOrderPrice.isUserInteractionEnabled = true
        }
        else {
            self.invoiceOrderPrice.isUserInteractionEnabled = false

        }

    }
}
