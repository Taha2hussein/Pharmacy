//
//  BlosgViewController.swift
//  Pharmacy
//
//  Created by A on 03/02/2022.
//

import UIKit
import RxSwift

class BlosgViewController: BaseViewController {

    @IBOutlet weak var uperView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var bligsTableView: UITableView!
    
    var articleDetailsViewModel = BlogViewModel()
    private var router = BlogRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        embedUperView()
        bindViewControllerRouter()
        subscribeToLoader()
        addSearchBarObserver()
        bindBlogsToTableView()
        articleDetailsViewModel.getBlogs(blogCountPerPage: 10)
    }
    
    func bindBlogsToTableView() {
        self.articleDetailsViewModel.Blogs
            .bind(to: self.bligsTableView
                    .rx
                    .items(cellIdentifier: String(describing:  BlogTableViewCell.self),
                           cellType: BlogTableViewCell.self)) { row, model, cell in
                
                cell.setData( product:model)

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
    
    private func addSearchBarObserver() {
            searchTextField
                .rx
                .text
                .orEmpty
                .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
                .distinctUntilChanged()
                .subscribe { [weak self] query in
                    guard
                        let query = query.element else { return }
                    print(query, "queryquery")
//                    self?.searchText.accept(query)
                }
                .disposed(by: disposeBag)
        }
    
    func embedUperView() {
        let vc = UperRouter().viewController
        self.embed(vc, inParent: self, inView: uperView)
    }

}

extension BlosgViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
