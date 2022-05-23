//
//  DailyTotalOrderCollectionViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 19/05/2022.
//

import UIKit

class DailyTotalOrderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dailyTotalOrderLabel: UILabel!
    @IBOutlet weak var dailyTotalOrderView: UIView!
    
    func setData( product:TotalDailyOrder) {
        
        if product.type == "جديد" {
            self.dailyTotalOrderLabel.text = LocalizedStrings().new
            dailyTotalOrderView.backgroundColor = .blue
        }
        if product.type == "في الانتظار" {
            self.dailyTotalOrderLabel.text = LocalizedStrings().Waiting
            dailyTotalOrderView.backgroundColor = .yellow
        }
        if product.type == "الغاء" {
            self.dailyTotalOrderLabel.text = LocalizedStrings().Canceled
            dailyTotalOrderView.backgroundColor = .red
        }
        if product.type == "تم التسليم" {
            dailyTotalOrderView.backgroundColor = .green
            self.dailyTotalOrderLabel.text = LocalizedStrings().Delivered
        }
        if product.type == "لم يحضر للتسليم" {
            dailyTotalOrderView.backgroundColor = .gray
            self.dailyTotalOrderLabel.text = LocalizedStrings().notDelivered
        }
        
//        self.dailyTotalOrderView.backgroundColor =
//        self.dailyTotalOrderLabel.text = product.
    }
}
