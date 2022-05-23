//
//  Singlton.swift
//  Pharmacy
//
//  Created by taha hussein on 06/04/2022.
//

import Foundation
import RxRelay
import RxCocoa
import RxSwift
class singlton {
    static let shared = singlton()
    var pharmacyOfferId = Int()
    var pushNotificatoinOrder = Int()
    var branchName = String()
    var selectedBrnachForAddPharmacist = [Int]()
    var selectedBrnachForAddPharmacistName = [String]()
    var userImage = [UploadDataa]()
    var deliverytime = String(0)
}
