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
    
    @IBOutlet weak var pharmacyName: UILabel!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    @IBOutlet weak var fromDateButton: UIButton!
    @IBOutlet weak var rechargeButton: UIButton!
    @IBOutlet weak var pharmacyLocation: UILabel!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var egmentedBar: UISegmentedControl!
    @IBOutlet weak var customContainer: UIView!
    @IBOutlet weak var expnseLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    
    // MARK: - Variables
    var container: walletContainerViewController!
    var articleDetailsViewModel = WalletsDetailsViewModel()
    private var router = WalletsDetailsRouter()
    private var DatePickers = DatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        container!.segueIdentifierReceivedFromParent("next")
        bindViewControllerRouter()
        setup()
        segmentAction()
        bindToPharmacyLabel()
        bindToPharmacyLocationLabel()
        bindToIncomeLabel()
        bindToExpnseLabel()
        bindToPharmacyImage()
        showFromDateAction()
        showEndDateAction()
        requestListBrhaches()
    }
    
    func setup() {
        articleDetailsViewModel.intializeData()
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
    
    func showFromDateAction() {
        fromDateButton.rx.tap.subscribe {[weak self] _ in
            self?.DatePickers.ShowPickerView(pickerView: self!, completionHandler: { date in
                self?.fromDateButton.setTitle(date, for: .normal)
            })
        } .disposed(by: self.disposeBag)
    }
    
    func showEndDateAction() {
        endDateButton.rx.tap.subscribe {[weak self] _ in
            self?.DatePickers.ShowPickerView(pickerView: self!, completionHandler: { date in
                self?.endDateButton.setTitle(date, for: .normal)
            })
        } .disposed(by: self.disposeBag)
        
    }
    
    func requestListBrhaches(){
        goButton.rx.tap.subscribe {[weak self] _ in
//            self?.articleDetailsViewModel.getWalletBranches(fromDate: (self?.fromDateButton.currentTitle ?? "") , endDate: (self?.endDateButton.currentTitle ?? ""))
        } .disposed(by: self.disposeBag)
        
    }
}
extension WalletDetailsViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}

extension WalletDetailsViewController {
    func bindToPharmacyLabel() {
        articleDetailsViewModel.pharmacyName
            .bind(to: pharmacyName.rx.text)
        .disposed(by: self.disposeBag)

    }
    
    func bindToPharmacyLocationLabel() {
        articleDetailsViewModel.pharmacyLocation
            .bind(to: pharmacyLocation.rx.text)
        .disposed(by: self.disposeBag)
    }
    
    func bindToIncomeLabel() {
        articleDetailsViewModel.pharmacyIncome
            .bind(to: incomeLabel.rx.text)
        .disposed(by: self.disposeBag)

    }
    
    func bindToExpnseLabel() {
        articleDetailsViewModel.pharmacyExpense
            .bind(to: expnseLabel.rx.text)
        .disposed(by: self.disposeBag)
    }
    
    func bindToPharmacyImage() {
        articleDetailsViewModel.pahrmacyImage.subscribe {[weak self] imageURL in
            self?.setImage(image: imageURL.element ?? "")
        }.disposed(by: self.disposeBag)

    }
    
    func setImage(image: String) {
        let imageURL =  baseURLImage + image
        if let url = URL(string: baseURLImage + (element?.profileImage ?? "")) {
            self?.ownerImage.load(url: url)
        }
    }
}
