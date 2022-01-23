//
//  WalletsViewController.swift
//  Pharmacy
//
//  Created by A on 20/01/2022.
//

import UIKit
import RxRelay
import RxSwift
import RxCocoa
import LinearProgressBar

class WalletsViewController: BaseViewController {

    @IBOutlet weak var linearExpnse: UILabel!
    @IBOutlet weak var LinearIncome: UILabel!
    @IBOutlet weak var totalExpnseLabel: UILabel!
    @IBOutlet weak var totalincomeLabel: UILabel!
    @IBOutlet weak var totalBalance: UILabel!
    @IBOutlet weak var linearProgressBar: LinearProgressBar!

    var articleDetailsViewModel = WalletsViewModel()
    private var router = WalletsRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        
        linearProgressBar.barColorForValue = { value in
            switch value {
            case 0..<20:
                return UIColor.red
            case 20..<60:
                return UIColor.orange
            case 60..<80:
                return UIColor.yellow
            default:
                return UIColor.green
            }
        }
            }

}
extension WalletsViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
