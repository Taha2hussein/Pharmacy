//
//  AllBranchesViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 09/03/2022.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

var branchSelected  = Int()
var removeSubview = BehaviorRelay<Bool>(value:false)
var showCancelPopViewAfterShowingBranches: Bool = false
class AllBranchesViewController: BaseViewController {
    
    @IBOutlet weak var branchesTableView: UITableView!
    @IBOutlet weak var closebutton: UIButton!
    
    var AddPharmacist = AddPharmacistViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removePopview()
        AddPharmacist.getPharmacyBranches()
        bindBranchToTableView()
        selectBranch()
    }
    
    func bindBranchToTableView() {
        AddPharmacist.AllBranchesInstance
            .bind(to: self.branchesTableView
                    .rx
                    .items(cellIdentifier: String(describing:  PopViewTableviewcell.self),
                           cellType: PopViewTableviewcell.self)) { row, model, cell in
                cell.brancheLabel.text = model.branchName
                
            }.disposed(by: self.disposeBag)
    }
    
    func selectBranch() {
        Observable.zip(branchesTableView
                        .rx
                        .itemSelected,branchesTableView.rx.modelSelected(AllBranchesBranch.self)).bind { [weak self] selectedIndex, product in
            branchSelected = product.branchID ?? 0
            removeSubview.accept(true)
            self?.view.removeFromSuperview()
        }.disposed(by: self.disposeBag)
    }
    
    func removePopview() {
        closebutton.rx
            .tap.subscribe { [weak self] _ in
                self?.view.removeFromSuperview()
            }.disposed(by: self.disposeBag)
    }
}
