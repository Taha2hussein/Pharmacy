//
//  BaseViewController.swift
//  RxSwiftTraining
//
//  Created by A on 07/12/2021.
//


import UIKit
import NVActivityIndicatorView
import PKHUD

class BaseViewController: CheckInternetViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        keyBoard(withPush: true)
    }
    
    func showLoading() {
        HUD.show(.progress, onView: self.view)
        
    }
    func hideLoading() {
        
        HUD.hide()
        
    }
    
    
    public static func show(_ content: HUDContentType, onView view: UIView? = nil) {
        PKHUD.sharedHUD.contentView = contentView(content)
        PKHUD.sharedHUD.show(onView: view)
    }
    
    fileprivate static func contentView(_ content: HUDContentType) -> UIView {
        switch content {
        case .success:
            return PKHUDSuccessView()
        case .error:
            return PKHUDErrorView()
        case .progress:
            return PKHUDProgressView()
        case let .image(image):
            return PKHUDSquareBaseView(image: image)
        case let .rotatingImage(image):
            return PKHUDRotatingImageView(image: image)
            
        case let .labeledSuccess(title, subtitle):
            return PKHUDSuccessView(title: title, subtitle: subtitle)
        case let .labeledError(title, subtitle):
            return PKHUDErrorView(title: title, subtitle: subtitle)
        case let .labeledProgress(title, subtitle):
            return PKHUDProgressView(title: title, subtitle: subtitle)
        case let .labeledImage(image, title, subtitle):
            return PKHUDSquareBaseView(image: image, title: title, subtitle: subtitle)
        case let .labeledRotatingImage(image, title, subtitle):
            return PKHUDRotatingImageView(image: image, title: title, subtitle: subtitle)
            
        case let .label(text):
            return PKHUDTextView(text: text)
        case .systemActivity:
            return PKHUDSystemActivityIndicatorView()
        case let .customView(view):
            return view
        }
    }
    
    
}
