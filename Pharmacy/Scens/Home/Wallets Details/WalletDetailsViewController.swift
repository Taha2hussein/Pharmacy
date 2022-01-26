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
    @IBOutlet weak var pharmacyView: UIView!
    
    //
    
    @IBOutlet weak var balnceView: UIView!
    @IBOutlet weak var totalBalance: UILabel!
    @IBOutlet weak var expnseLabel_Balance: UILabel!
    @IBOutlet weak var incomeLabel_Blance: UILabel!
    // MARK: - Variables
    var container: walletContainerViewController!
    var articleDetailsViewModel = WalletsDetailsViewModel()
    private var router = WalletsDetailsRouter()
    private var DatePickers = DatePicker()
    var previosView: previosView?
    private var branchIDForPharmacy = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        container!.segueIdentifierReceivedFromParent("next")
        bindViewControllerRouter()
        segmentAction()
        showFromDateAction()
        showEndDateAction()
        requestListBrhaches()
        checkView()
        subscribeToLoader()
        rechargeAction()
    }
    
    func checkView() {
        if previosView == .pharmacy {
            balnceView.isHidden = true
            bindToPharmacyLabel()
            bindToPharmacyLocationLabel()
            bindToIncomeLabel()
            bindToExpnseLabel()
            bindToPharmacyImage()
            subsribeToBranch()
            articleDetailsViewModel.intializeData()
        }
        
        else {
            pharmacyView.isHidden = true
            articleDetailsViewModel.intializeDataForBalance()
            bindToTotalBalance()
            bindToTotalInce()
            bindToITotalExpnse()
            bindToIncome()
            bindToExpnse()
        }
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
    
    func subscribeToLoader() {
        articleDetailsViewModel.state.isLoading.subscribe(onNext: {[weak self] (isLoading) in
            DispatchQueue.main.async {
                if isLoading {
                    
                    self?.showLoading()
                    
                } else {
                    self?.hideLoading()
                }
            }
        }).disposed(by: self.disposeBag)
    }
    
    func requestListBrhaches(){
        goButton.rx.tap.subscribe {[weak self] _ in
            self?.articleDetailsViewModel.getWalletTransactionList(branchId: self?.branchIDForPharmacy ?? "", fromDate: (self?.fromDateButton.currentTitle ?? ""), endDate: (self?.endDateButton.currentTitle ?? ""))
        } .disposed(by: self.disposeBag)
        
    }
    
    func rechargeAction() {
        rechargeButton.rx.tap.subscribe {[weak self] _ in
            self?.showRechargeSubView()
        } .disposed(by: self.disposeBag)
    }
    
    func showRechargeSubView() {
        let view = UIStoryboard.init(name: Storyboards.Recharge.rawValue, bundle: nil)
        let viewController = view.instantiateViewController(withIdentifier: ViewController.RechageView.rawValue)
        viewController.view.frame = self.view.bounds
        self.view.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
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
    
    func subsribeToBranch() {
        articleDetailsViewModel.branchId.subscribe { [weak self] branchId in
            self?.branchIDForPharmacy = branchId
        } .disposed(by: self.disposeBag)

    }
    
    func bindToPharmacyImage() {
        articleDetailsViewModel.pahrmacyImage.subscribe {[weak self] imageURL in
            self?.setImage(image: imageURL.element ?? "")
        }.disposed(by: self.disposeBag)
        
    }
    
    func setImage(image: String) {
        if let url = URL(string: baseURLImage + (image ?? "")) {
            self.ownerImage.load(url: url)
        }
    }
}

// for Balance
extension WalletDetailsViewController {
    
    func bindToTotalBalance() {
        articleDetailsViewModel.totalBalance
            .bind(to: totalBalance.rx.text)
            .disposed(by: self.disposeBag)
        
    }
    
    func bindToTotalInce() {
        articleDetailsViewModel.totalIncome
            .bind(to: incomeLabel_Blance.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    func bindToITotalExpnse() {
        articleDetailsViewModel.totalExpnse
            .bind(to: expnseLabel_Balance.rx.text)
            .disposed(by: self.disposeBag)
        
    }
    
    func bindToIncome() {
        articleDetailsViewModel.pharmacyIncome
            .bind(to: incomeLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    func bindToExpnse() {
        articleDetailsViewModel.pharmacyExpense
            .bind(to: expnseLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
}
