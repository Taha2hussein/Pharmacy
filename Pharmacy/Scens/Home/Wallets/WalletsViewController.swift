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
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var branchListTableView: UITableView!
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
        subscribeToLoader()
        articleDetailsViewModel.getWallet()
        subsribeToWallet()
        requestListBrhaches()
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
                self?.totalBalance.text = "\(Int(walletElement?.message?.totalBalance ?? 0))"
                self?.totalincomeLabel.text = "\(Int(walletElement?.message?.totalIncome ?? 0))"
                self?.totalExpnseLabel.text = "\(Int(walletElement?.message?.totalExpense ?? 0))"
                self?.LinearIncome.text = "\(Int(walletElement?.message?.totalIncome ?? 0))"
                self?.linearExpnse.text = "\(Int(walletElement?.message?.totalExpense ?? 0))"

            }
        }.disposed(by: self.disposeBag)

    }
    
    func requestListBrhaches(){
        goButton.rx.tap.subscribe {[weak self] _ in
            self?.articleDetailsViewModel.getWalletBranches()
        } .disposed(by: self.disposeBag)

    }
}
extension WalletsViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
