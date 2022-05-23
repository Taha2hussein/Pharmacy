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
    var bag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
//        totalOrderInvoicePrice.onNext(0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setData(orderInvoice: Medicine?) {
        self.invoiceOrderQuantity.text = orderInvoice?.medicineAmountDetailsLocalized
        self.invoiceOrderPrice.text = "\(orderInvoice?.price ?? 0)"
        self.invoiceOrderQuantity.text = orderInvoice?.medicineAmountDetailsLocalized
        self.orderInvoiceName.text = "1x  " + (orderInvoice?.nameLocalized ?? "")
//        orderInvoicePrice = orderInvoice?.price ?? 0
//        totalOrderInvoicePrice.onNext(orderInvoicePrice)

    }
}
