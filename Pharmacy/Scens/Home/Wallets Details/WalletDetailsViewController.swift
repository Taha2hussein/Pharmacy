//
//  WalletDetailsViewController.swift
//  Pharmacy
//
//  Created by A on 21/01/2022.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class WalletDetailsViewController: BaseViewController {
    
    @IBOutlet weak var egmentedBar: UISegmentedControl!
    @IBOutlet var customContainer: UIView!
    
    var container: walletContainerViewController!
    var articleDetailsViewModel = WalletsDetailsViewModel()
    private var router = WalletsDetailsRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        container!.segueIdentifierReceivedFromParent("next")
        bindViewControllerRouter()
        segmentAction()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "container"{
          container = segue.destination as? walletContainerViewController
          container.animationDurationWithOptions = (0.5, .transitionCrossDissolve)
          }
      }
    
    
    func segmentAction() {
        egmentedBar.rx.selectedSegmentIndex.subscribe { [weak self] index in
            if index.element == 0 {
  // handle DAta
                print("all")
            } else if index.element == 1 {
                // handle DAta
                print("received")

              
            }
            
            else {
                // handle DAta
                print("used")

            }
            
        }.disposed(by: self.disposeBag)

    }
}
extension WalletDetailsViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
