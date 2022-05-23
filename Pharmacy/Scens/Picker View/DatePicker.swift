//
//  DatePicker.swift
//  Pharmacy
//
//  Created by A on 26/01/2022.
//

import Foundation
import UIKit
import DateTimePicker

class DatePicker: DateTimePickerDelegate {
    
    var title = String()
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        title = picker.selectedDateString
    }
    
    func ShowPickerView(pickerView: UIViewController , completionHandler: @escaping((String)->()))
    {
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 60)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
        let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
        
        picker.dateFormat = "YYYY-MM-dd"
        picker.includesMonth = true
        picker.includesSecond = true
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.doneButtonTitle = "DONE"
        picker.doneBackgroundColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.customFontSetting = DateTimePicker.CustomFontSetting(selectedDateLabelFont: .boldSystemFont(ofSize: 20))
        
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd"
            self.title = formatter.string(from: date)
            completionHandler(self.title)
        }
        picker.delegate = self
        
        picker.show()
        
    }
}
