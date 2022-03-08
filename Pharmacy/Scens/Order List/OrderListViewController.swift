//
//  OrderListViewController.swift
//  Pharmacy
//
//  Created by Amr on 03/03/2022.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

enum orderSegment {
    case needAction
    case upcoming
    case completed
}

class OrderListViewController: BaseViewController {
    
    @IBOutlet weak var orderSegment: UISegmentedControl!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var filterTextField: UITextField!
    @IBOutlet weak var uperView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var articleDetailsViewModel = OrderListViewModel()
    private var router = OrderListRouter()
    private var orderSelected: orderSegment = .needAction
    
    override func viewDidLoad() {
        super.viewDidLoad()
        embedUperView()
        setup()
        bindViewControllerRouter()
        segmentAction()
        bindordersoTableView()
        subscribeToLoader()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        articleDetailsViewModel.getOrderList(segmentSelected: 1)
    }
    
    func setup(){
        self.tableView.rowHeight = 100
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
    
    
    func bindordersoTableView() {
        articleDetailsViewModel.ordersInstance
            .bind(to: self.tableView
                    .rx
                    .items(cellIdentifier: String(describing:  OrderListTableViewCell.self),
                           cellType: OrderListTableViewCell.self)) { row, model, cell in
                cell.setUPOrders(order: model)

            }.disposed(by: self.disposeBag)
    }
    
    func segmentAction() {
        orderSegment.rx.selectedSegmentIndex.subscribe { [weak self] index in
            if index.element == 0 {
                self?.articleDetailsViewModel.getOrderList(segmentSelected: 1)
            }  else if index.element == 1{
                self?.articleDetailsViewModel.getOrderList(segmentSelected: 2)
            } else {
                self?.articleDetailsViewModel.getOrderList(segmentSelected: 3)
            }
            
            
        }.disposed(by: self.disposeBag)
    }
    
    func embedUperView() {
        let vc = UperRouter().viewController
        self.embed(vc, inParent: self, inView: uperView)
    }

}

extension OrderListViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
