//
//  BrnachPopViewViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 20/04/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class BrnachPopViewViewController: BaseViewController {
    
//    var AllBranchesInstance = PublishSubject<[AllBranchesBranch]>()
    var AddPharmacist = AddPharmacistViewModel()

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var branchtableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButtonAction()
        setUP()
        selectBranch()
        bindBrnahcesToTableView()
        cancelTapped()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AddPharmacist.getPharmacyBranches()
    }

    func setUP() {
        self.view.backgroundColor = .black.withAlphaComponent(0.5)

    }

    func cancelTapped() {
        cancelButton.rx.tap.subscribe { [weak self] _ in
            self?.view.removeFromSuperview()
        }.disposed(by: self.disposeBag)

    }
 
    func saveButtonAction() {
        saveButton.rx.tap.subscribe {[weak self] _ in
            selectBrnachObserver.onNext(true)
            self?.view.removeFromSuperview()
        }.disposed(by: self.disposeBag)
        
    }
    
    func selectBranch() {

            let _ = branchtableView.rx.modelSelected(AllBranchesBranch.self).subscribe { item in
        
            singlton.shared.selectedBrnachForAddPharmacist.append(item.element?.branchID ?? 0)
            singlton.shared.selectedBrnachForAddPharmacistName.append(item.element?.branchName ?? "")
          }
        
          let _ = branchtableView.rx.modelDeselected(AllBranchesBranch.self).subscribe { item in
              if let index = singlton.shared.selectedBrnachForAddPharmacist.firstIndex(where: {$0 == (item.element?.branchID ?? 0)}){
                  singlton.shared.selectedBrnachForAddPharmacist.remove(at: index)
                  singlton.shared.selectedBrnachForAddPharmacistName.remove(at: index)
              }
                print("deselected: \(item)")
          }
    }
    
    
    func bindBrnahcesToTableView() {
        self.AddPharmacist.AllBranchesInstance
            .bind(to: self.branchtableView
                .rx
                .items(cellIdentifier: String(describing:  BranchesPopViewCell.self),
                       cellType: BranchesPopViewCell.self)) { row, model, cell in
                cell.setDate(branches: model)
                
            }.disposed(by: self.disposeBag)
    }
}
