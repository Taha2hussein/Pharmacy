//
//  Alert.swift
//  MachineTest
//
//  Created by A on 16/12/2021.
//


import UIKit


class Alert : NSObject{
    func displayError(text: String , viewController : UIViewController){
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let cancelButton = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancelButton)
        viewController.present(alert, animated: true, completion: nil)
    }
}
