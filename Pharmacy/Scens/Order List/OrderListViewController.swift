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
var orderSelected: orderSegment = .needAction

class OrderListViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var orderSegment: UISegmentedControl!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var filterTextField: UITextField!
    @IBOutlet weak var uperView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var articleDetailsViewModel = OrderListViewModel()
    private var router = OrderListRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        embedUperView()
        setup()
        bindViewControllerRouter()
        segmentAction()
        subscribeToLoader()
        LocalizeSegemnet()
        selectOrderAction()
        filterTextField.delegate = self
        bindordersoTableView()
        filterTapped()
    
    }
    
    func LocalizeSegemnet() {
        
        orderSegment.setTitle("Need Action".localized, forSegmentAt: 0)
        orderSegment.setTitle("Uncomplete".localized, forSegmentAt: 1)
        orderSegment.setTitle("Complete".localized, forSegmentAt: 2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        orderSegment.selectedSegmentIndex = 0
        orderSelected = .needAction
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
    
    func validateEmptyOrders() {
        articleDetailsViewModel.ordersInstance.subscribe { [weak self] orders in
            let orderCount = orders.element
            if orderCount?.count == 0 {
                self?.showToast(LocalizedStrings().emptySearchData)
            }
        }.disposed(by: self.disposeBag)

    }
    
    func filterTapped() {
        filterButton.rx.tap.subscribe { [weak self] _ in
            self?.router.showFilter()
        }.disposed(by: self.disposeBag)

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
    
    func selectOrderAction() {
        
        Observable.zip(tableView
            .rx
            .itemSelected,tableView.rx.modelSelected(OrderListMessage.self)).bind { [weak self] selectedIndex, product in
                
                PharmacyProviderBranchFk = product.pharmacyBranchFk ?? 0
                if orderSelected == .completed {
                    self?.router.showCanceledOrder(orderId: product.orderID ?? 0, singleOrderStatus: product.singleOrderStatus ?? 5)
                }
                
                // 0  for new or 1 for other
                else if orderSelected == .needAction {
                    self?.router.showOrderTracking(orderId: product.orderID ?? 0, singleOrderStatus: product.singleOrderStatus ?? 0 )
                    saveOrderForCusomerSuccess.onNext(true)
                }
                
                else {
                    self?.router.showOrderTracking(orderId: product.orderID ?? 0, singleOrderStatus: product.singleOrderStatus ?? 0)
                    toggleFinishOrderView.onNext(true)
                }
                
            }.disposed(by: self.disposeBag)
    }
    
    func segmentAction() {
        orderSegment.rx.selectedSegmentIndex.subscribe { [weak self] index in
            self?.filterTextField.text = ""
            if index.element == 0 {
                orderSelected  = .needAction
                self?.articleDetailsViewModel.getOrderList(segmentSelected: 1)
                
            }  else if index.element == 1{
                orderSelected  = .upcoming
                self?.articleDetailsViewModel.getOrderList(segmentSelected: 2)
                
            } else {
                orderSelected  = .completed
                self?.articleDetailsViewModel.getOrderList(segmentSelected: 3)
            }
        }.disposed(by: self.disposeBag)
    }
    
    
    @IBAction func searchOrderAction(_ sender: UITextField) {
        if  let searchText = sender.text {
            guard let sections = try? articleDetailsViewModel.ordersInstance.value() else { return  }
            guard let sectionsTemp = try? articleDetailsViewModel.ordersInstanceTemp.value() else { return  }
            var filterArr = (sections.filter({(($0.orderNo)!.localizedCaseInsensitiveContains(searchText) || ($0.patientName)!.localizedCaseInsensitiveContains(searchText))}))

            if filterArr.count > 0 {
                articleDetailsViewModel.ordersInstance.onNext(filterArr)
            }
            else {
                filterArr.removeAll()
                articleDetailsViewModel.ordersInstance.onNext(filterArr)
                showToast(LocalizedStrings().emptySearchData)
                
            }
            
            if searchText == "" {
                filterArr.removeAll()
                articleDetailsViewModel.ordersInstance.onNext(sectionsTemp)
            }
            self.tableView.reloadData()
        }
    }
    
    func embedUperView() {
        let vc = UperRouter(headerTilte: "Order".localized).viewController
        self.embed(vc, inParent: self, inView: uperView)
    }
}

extension OrderListViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
