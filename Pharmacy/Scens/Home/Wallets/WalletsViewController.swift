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
import DateTimePicker

class WalletsViewController: BaseViewController {
    
    @IBOutlet weak var endDate: UIButton!
    @IBOutlet weak var fromDate: UIButton!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var branchListTableView: UITableView!
    @IBOutlet weak var linearExpnse: UILabel!
    @IBOutlet weak var LinearIncome: UILabel!
    @IBOutlet weak var totalExpnseLabel: UILabel!
    @IBOutlet weak var totalincomeLabel: UILabel!
    @IBOutlet weak var totalBalance: UILabel!
    @IBOutlet weak var linearProgressBar: MultiProgressView!
    @IBOutlet weak var balanceView: UIView!
    
    var articleDetailsViewModel = WalletsViewModel()
    private var router = WalletsRouter()
    private var DatePickers = DatePicker()
    private var WalletElement: WalletModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        subscribeToLoader()
        subsribeToWallet()
        requestListBrhaches()
        subsribetoBranchList()
        showFromDateAction()
        showEndDateAction()
        selectBranch()
        articleDetailsViewModel.getWallet()
        setGesturesForBalanceView()
    
    }
    
    private func animateProgress(incomde:Double, expanse:Double) {

        let incomeProgress = Progress(totalUnitCount: Int64(incomde))
        let expnseProgress = Progress(totalUnitCount: Int64(expanse))

        linearProgressBar.add(incomeProgress, progressTintColor: .green)
        linearProgressBar.add(expnseProgress, progressTintColor: .purple)

    }
  
    func setGesturesForBalanceView() {
        let balanceView = UITapGestureRecognizer(target: self, action: #selector(self.tabBalnce))
        self.balanceView.isUserInteractionEnabled = true
        self.balanceView.addGestureRecognizer(balanceView)
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
    
    func subsribetoBranchList() {
        self.articleDetailsViewModel.walletBrhacnList
            .bind(to: self.branchListTableView
                    .rx
                    .items(cellIdentifier: String(describing:  BranchTableViewCell.self),
                           cellType: BranchTableViewCell.self)) { row, model, cell in
                
                cell.setData( product:model)
            }.disposed(by: self.disposeBag)
    }
    
    func subsribeToWallet() {
        articleDetailsViewModel.wallet.subscribe {[weak self] wallet in
            DispatchQueue.main.async {
                let walletElement = wallet.element
                self?.WalletElement = walletElement
                self?.totalBalance.text = "\(Int(walletElement?.message?.totalBalance ?? 0))" + " EGP".localized
                self?.totalincomeLabel.text = "\(Int(walletElement?.message?.totalIncome ?? 0))"
                self?.totalExpnseLabel.text = "\(Int(walletElement?.message?.totalExpense ?? 0))"
                self?.LinearIncome.text = "\(Int(walletElement?.message?.totalIncome ?? 0))" + " EGP".localized
                self?.linearExpnse.text = "\(Int(walletElement?.message?.totalExpense ?? 0))" + " EGP".localized
                self?.animateProgress(incomde: Double(walletElement?.message?.totalIncome ?? 0.0), expanse: Double(walletElement?.message?.totalExpense ?? 0.0))
            }
        }.disposed(by: self.disposeBag)
        
    }
    
    func showFromDateAction() {
        fromDate.rx.tap.subscribe {[weak self] _ in
            self?.DatePickers.ShowPickerView(pickerView: self!, completionHandler: { date in
                self?.fromDate.setTitle(date, for: .normal)
            })
        } .disposed(by: self.disposeBag)
    }
    
    func showEndDateAction() {
        endDate.rx.tap.subscribe {[weak self] _ in
            self?.DatePickers.ShowPickerView(pickerView: self!, completionHandler: { date in
                self?.endDate.setTitle(date, for: .normal)
            })
        } .disposed(by: self.disposeBag)
        
    }
    
    func requestListBrhaches(){
        goButton.rx.tap.subscribe {[weak self] _ in
            self?.articleDetailsViewModel.getWalletBranches(fromDate: (self?.fromDate.currentTitle ?? "") , endDate: (self?.endDate.currentTitle ?? ""))
        } .disposed(by: self.disposeBag)
        
    }
    
    func selectBranch() {
        Observable.zip(branchListTableView
                        .rx
                        .itemSelected,branchListTableView.rx.modelSelected(BrahcnListMessage.self)).bind { [weak self] selectedIndex, product in
                            
                            singlton.shared.branchName = product.branchNameLocalized ?? ""
                            
            self?.articleDetailsViewModel.showDetailsBranch(source: product , previosView: .pharmacy)
        }.disposed(by: self.disposeBag)
    }
}

extension WalletsViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}

extension WalletsViewController {
    @objc
    func tabBalnce(sender:UITapGestureRecognizer) {
        articleDetailsViewModel.showDetailsBranch_Balance(source: WalletElement , previosView: .balance)
    }
        
}



