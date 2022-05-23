//
//  BlosgViewController.swift
//  Pharmacy
//
//  Created by A on 03/02/2022.
//

import UIKit
import RxSwift
import Social
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
        //        subscribeToToogleLike()
        selectBlog()
        bindBlogsToTableView()
        articleDetailsViewModel.getBlogs(blogCountPerPage: 100)
    }
    
    
    func bindBlogsToTableView() {
        self.articleDetailsViewModel.Blogs
            .bind(to: self.bligsTableView.rx
                .items(cellIdentifier: String(describing:  BlogTableViewCell.self),
                       cellType: BlogTableViewCell.self)) {[weak self] row, model, cell in
                cell.setData( product:model)
                
                cell.likeButton.rx.tap.subscribe { [weak self] _ in
                self?.articleDetailsViewModel.unlikeBlog(blogID: model.blogID ?? 0)
                    cell.unLikeButton.isHidden = false
                    cell.likeButton.isHidden = true
                } .disposed(by: cell.bag)
                
                cell.unLikeButton.rx.tap.subscribe { [weak self] _ in
                self?.articleDetailsViewModel.likeBlog(blogID: model.blogID ?? 0)
                    cell.unLikeButton.isHidden = true
                    cell.likeButton.isHidden = false
                }.disposed(by: cell.bag)
                
                // share
                cell.shateButton.rx.tap.subscribe { [weak self] _ in
                    self?.shareToFaceBookAction(posts: model)
                } .disposed(by: cell.bag)
                
            }.disposed(by: self.disposeBag)
        
    }
    
    func shareToFaceBookAction(posts:BlogMessage) {
        if let message = posts.blogTitle {
        if let link = URL(string: baseURLImage + (posts.blogFilePath ?? "")) {
            print(link, "links")
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
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
    
    func selectBlog() {
        Observable.zip(bligsTableView
            .rx
            .itemSelected,bligsTableView.rx.modelSelected(BlogMessage.self)).bind { [weak self] selectedIndex, product in
                self?.articleDetailsViewModel.showBlogsDetails(blogDetailId: product.blogID ?? 0)
            }.disposed(by: self.disposeBag)
    }
    
    func embedUperView() {
        let vc = UperRouter(headerTilte: "Blog".localized).viewController
        self.embed(vc, inParent: self, inView: uperView)
    }
    
    @IBAction func searchBlogAction(_ sender: UITextField) {
                if  let searchText = sender.text {
                    guard let sections = try? articleDetailsViewModel.Blogs.value() else { return  }
                    guard let sectionsTemp = try? articleDetailsViewModel.BlogsTemp.value() else { return  }
                    var filterArr = (sections.filter({(($0.blogTitle)!.localizedCaseInsensitiveContains(searchText))}))
        
                    if filterArr.count > 0 {
                        articleDetailsViewModel.Blogs.onNext(filterArr)
                    }
                    else {
                        filterArr.removeAll()
                        articleDetailsViewModel.Blogs.onNext(filterArr)
                        showToast(LocalizedStrings().emptySearchData)
        
                    }
        
                    if searchText == "" {
                        filterArr.removeAll()
                        articleDetailsViewModel.Blogs.onNext(sectionsTemp)
                    }
                    self.bligsTableView.reloadData()
                }
    }
}

extension BlosgViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
