//
//  FAQViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 05/05/2022.
//

import UIKit
import RxRelay
import RxSwift
import RxCocoa

class FAQViewController: BaseViewController {

    @IBOutlet weak var faqTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var articleDetailsViewModel = FAQViewModel()
    private var router = FAQRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindFAQToTablwView()
        bindViewControllerRouter()
        backTapped()
        articleDetailsViewModel.getWebPage()
        subscribeToLoader()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    func setup() {
        
        self.faqTableView.estimatedRowHeight = 100
        faqTableView.rowHeight = UITableView.automaticDimension
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
    
    func bindFAQToTablwView() {
            articleDetailsViewModel.faqInstance
                .bind(to: self.faqTableView
                    .rx
                    .items(cellIdentifier: String(describing:  FAQTableViewCell.self),
                           cellType: FAQTableViewCell.self)) { row, model, cell in
                    cell.setData( FAQ:model)
                    
                }.disposed(by: self.disposeBag)
        
    }
    
    func backTapped() {
        backButton.rx.tap.subscribe { [weak self] _ in
            self?.router.backAction()
        } .disposed(by: self.disposeBag)

    }
}

extension FAQViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
