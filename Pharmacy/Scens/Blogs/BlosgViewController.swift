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
    private weak var cell : BlogTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        embedUperView()
        bindViewControllerRouter()
        subscribeToLoader()
        subscribeToToogleLike()
        selectBlog()
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
                    // like button
                    cell.likeButton.rx.tap.subscribe { [weak self] _ in
                        DispatchQueue.main.async {
                        self?.cell = cell
                        if (model.amILiked!) {
                            self?.articleDetailsViewModel.unlikeBlog(blogID: model.blogID ?? 0)
                        }
                        else {
                            self?.articleDetailsViewModel.likeBlog(blogID: model.blogID ?? 0)
                            }
                        }
                    } .disposed(by: self.disposeBag)
                    
                    // share
                    cell.likeButton.rx.tap.subscribe { [weak self] _ in
                        
                    } .disposed(by: self.disposeBag)
                    
                }.disposed(by: self.disposeBag)
            
    }
    
    func subscribeToToogleLike() {
        // correct but need to bind to cell
        articleDetailsViewModel.toogleLikeIcon.subscribe(onNext: {[weak self] (toogle) in
            DispatchQueue.main.async {
                if toogle {
                    self?.cell?.likeButton.setImage(UIImage(named:"avatar"), for: .normal)
                } else {
                    self?.cell?.likeButton.setImage(UIImage(named:"like"), for: .normal)
                }
            }
        }).disposed(by: self.disposeBag)
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
    
    func selectBlog() {
        Observable.zip(bligsTableView
                        .rx
                        .itemSelected,bligsTableView.rx.modelSelected(BlogMessage.self)).bind { [weak self] selectedIndex, product in
            self?.articleDetailsViewModel.showBlogsDetails(blogDetailId: product.blogID ?? 0)
        }.disposed(by: self.disposeBag)
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
