//
//  BlogDetailsViewController.swift
//  Pharmacy
//
//  Created by taha hussein on 12/02/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
class BlogDetailsViewController: BaseViewController {
    
    var articleDetailsViewModel = BlogDetailsViewModel()
    private var router = BlogDetailsRouter()
    
    @IBOutlet weak var blogDesribtionHeight: NSLayoutConstraint!
    @IBOutlet weak var blogDescribtion: UITextView!
    @IBOutlet weak var blogDate: UILabel!
    @IBOutlet weak var blogAuthor: UILabel!
    @IBOutlet weak var blogAvatar: UIImageView!
    @IBOutlet weak var blogName: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likedbutton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var blogDetailImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleDetailsViewModel.getBlogDetails()
        bindViewControllerRouter()
        subsribetoblogDetail()
        subscribeToLoader()
        backview()
    }
    

    func subsribetoblogDetail() {
        articleDetailsViewModel.blogDetailsObject.subscribe {[weak self] blogDetails in
            DispatchQueue.main.async {
                self?.assingBlogDetail(blogDetails: blogDetails)
            }
        } .disposed(by: self.disposeBag)

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
    
    func assingBlogDetail(blogDetails: BlogDetailsModel) {
        self.blogName.text = blogDetails.message?.blogTitle
        self.blogDate.text = blogDetails.message?.createDate
        self.blogDescribtion.text =  blogDetails.message?.blogText
        blogDescribtion.adjustUITextViewHeight()
        self.likedbutton.setTitle((blogDetails.message?.likeCountText ?? "0") + " likes", for: .normal)
        let pwnerName = LocalStorage().getownerFirstName()
        self.blogAuthor.text = "Dr. " + pwnerName
        if let url = URL(string: baseURLImage + (blogDetails.message?.blogFilePath ?? "")) {
            self.blogDetailImage.load(url: url)
        }
    }
    
    func backview() {
        backButton.rx.tap.subscribe { [weak self] _  in
            self?.articleDetailsViewModel.backNavigationview()
        }.disposed(by: self.disposeBag)

    }
}
extension BlogDetailsViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
