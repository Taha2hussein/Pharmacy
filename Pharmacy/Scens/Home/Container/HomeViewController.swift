//
//  HomeViewController.swift
//  Pharmacy
//
//  Created by A on 20/01/2022.
//

import UIKit
import RxRelay
import RxCocoa
import RxSwift

class HomeViewController: BaseViewController {

    @IBOutlet weak var uperView: UIView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    var container: ContainerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        segmentAction()
        container!.segueIdentifierReceivedFromParent("previous")
//        embedUperView()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "container"{
              container = segue.destination as? ContainerViewController
              container.animationDurationWithOptions = (0.5, .transitionCrossDissolve)
          }
      }
    
    func segmentAction() {
        segmentController.rx.selectedSegmentIndex.subscribe { [weak self] index in
            if index.element == 0 {
  
                self?.container!.segueIdentifierReceivedFromParent("previous")
                
            } else {

                self?.container!.segueIdentifierReceivedFromParent("next")

            }
        }.disposed(by: self.disposeBag)

    }

    func embedUperView() {
        let vc = UperRouter().viewController
        self.embedd(into: self, childController: vc, containerView: uperView)
    }
}
