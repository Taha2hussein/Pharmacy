//
//  BasicData.swift
//  Pharmacy
//
//  Created by taha hussein on 24/04/2022.
//

import Foundation
class BasicData {
    var pharmacyNameEn: String
    var pharmacyNameAr: String
    var pharmacyAboutEn: String
    var pharmacyAboutAr: String
    var image: String
    var TimeToRespondTheOrderInHours: Int
    var Files: [String]
    
    init(pharmacyNameEn:String , pharmacyNameAr:String ,pharmacyAboutEn:String ,  pharmacyAboutAr:String,image:String, TimeToRespondTheOrderInHours: Int,Files:[String]) {
        self.pharmacyNameEn = pharmacyNameEn
        self.pharmacyNameAr = pharmacyNameAr
        self.pharmacyAboutEn = pharmacyAboutEn
        self.pharmacyAboutAr = pharmacyAboutAr
        self.image = image
        self.TimeToRespondTheOrderInHours = TimeToRespondTheOrderInHours
        self.Files = Files

        
    }

}
