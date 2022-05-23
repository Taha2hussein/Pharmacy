//
//  NotificationListViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 19/05/2022.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay

class NotificationListViewController: BaseViewController {

    @IBOutlet weak var readAndDeleteStackView: UIStackView!
    @IBOutlet weak var deleteAllNotificationButton: UIButton!
    @IBOutlet weak var readAllNotificationButton: UIButton!
    @IBOutlet weak var notifcaiotnListTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var articleDetailsViewModel = NotificationListViewModel()
    private var router = NotificationListRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        subscribeToLoader()
        setup()
        backButtonTapped()
        bindNotifcaiontsToTablwView()
        articleDetailsViewModel.getNotificationList()
        markAllNotificationtapped()
        deleteAllNotificationtapped()
        subscribeToNotifications()
    }
 
    func setup() {
        
        notifcaiotnListTableView.estimatedRowHeight = 120
        notifcaiotnListTableView.rowHeight = UITableView.automaticDimension
    }
    
    func backButtonTapped() {
        backButton.rx.tap.subscribe { [weak self] _ in
            self?.router.backAction()
        }.disposed(by: self.disposeBag)

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
    
    func subscribeToNotifications() {
        articleDetailsViewModel.notificationListInstance.subscribe { [weak self] notficationList in
            if let notifcationCount = notficationList.element?.count {
                if notifcationCount == 0 {
                    self?.readAndDeleteStackView.isHidden = true
                }
                else {
                    self?.readAndDeleteStackView.isHidden = false

                }
            }
        }

    }
    func bindNotifcaiontsToTablwView() {
            articleDetailsViewModel.notificationListInstance
                .bind(to: self.notifcaiotnListTableView
                    .rx
                    .items(cellIdentifier: String(describing:  NotifcationListTableViewCell.self),
                           cellType: NotifcationListTableViewCell.self)) { row, model, cell in
                    cell.setData( notification:model)
                    
                    // deleteNotificatoion
                    
                    cell.notificationDelete.rx.tap.subscribe { [weak self] _ in
                        self?.articleDetailsViewModel.deleteNotificationAction(notificationID: model.userNotificationID ?? 0)
                        self?.removenotification(row: row)
                    }.disposed(by: cell.bag)

                    
                    cell.notificationReadButton.rx.tap.subscribe { [weak self] _ in
                        self?.articleDetailsViewModel.markNotificationAction(notificationID: model.userNotificationID ?? 0)
                    } .disposed(by: self.disposeBag)

                }.disposed(by: self.disposeBag)
        
    }

    func markAllNotificationtapped() {
        readAllNotificationButton.rx.tap.subscribe { [weak self] _ in
            self?.articleDetailsViewModel.markAllNotificationAction()
        } .disposed(by: self.disposeBag)

    }
    
    func deleteAllNotificationtapped() {
        deleteAllNotificationButton.rx.tap.subscribe { [weak self] _ in
            self?.articleDetailsViewModel.deleteAllNotificationAction()
        } .disposed(by: self.disposeBag)

    }
    
    func removeAllNotification() {
        guard var sections = try? self.articleDetailsViewModel.notificationListInstance.value() else { return }
        
        sections.removeAll()
        self.articleDetailsViewModel.notificationListInstance.onNext(sections)
    }
    
    func reloadNoticationsTableView() {
        self.notifcaiotnListTableView.reloadData()
    }
    
    func removenotification(row:Int) {
        guard var sections = try? self.articleDetailsViewModel.notificationListInstance.value() else { return }
        
        sections.remove(at: row)
        self.articleDetailsViewModel.notificationListInstance.onNext(sections)
    }
}
extension NotificationListViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
