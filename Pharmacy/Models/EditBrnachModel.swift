//
//  EditBrnachModel.swift
//  Pharmacy
//
//  Created by taha hussein on 20/04/2022.
//

import Foundation
// MARK: - EditBrnachModel
struct EditBrnachModel: Codable {
    var successtate: Int?
    var errormessage: String?
    var message: EditBrnachMessage?
}

// MARK: - Message
struct EditBrnachMessage: Codable {
    var pharmacyProviderBranchID, pharmacyProviderFk: Int?
    var branchNameEn, branchNameAr, mobileCode, mobileNumber: String?
    var countryID, cityID: Int?
    var cityName: String?
    var areaID: Int?
    var areaName, address, landMarkEn, landMarkAr: String?
    var hasDelivery: Bool?
    var deliveryFees:Int?
    var deliveryTimeInMinuts: Int?
    var provideServiceInKM: Int?
    var twintyFourHoursService: Bool?
    var openinigTime, closingTime: String?
    var paymentType: Int?
    var lat, lang: String?

    enum CodingKeys: String, CodingKey {
        case pharmacyProviderBranchID = "pharmacyProviderBranchId"
        case pharmacyProviderFk, branchNameEn, branchNameAr, mobileCode, mobileNumber, countryID, cityID, cityName, areaID, areaName, address, landMarkEn, landMarkAr, hasDelivery, deliveryFees, deliveryTimeInMinuts
        case provideServiceInKM = "provideServiceInKm"
        case twintyFourHoursService, openinigTime, closingTime, paymentType, lat, lang
    }
}
