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
import SDWebImage
class BlogDetailsViewController: BaseViewController {
    
    var articleDetailsViewModel = BlogDetailsViewModel()
    private var router = BlogDetailsRouter()
    private var postDetails: BlogDetailsModel?
    
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
        sharePostTapped()
    }
    

    func subsribetoblogDetail() {
        articleDetailsViewModel.blogDetailsObject.subscribe {[weak self] blogDetail in
            DispatchQueue.main.async {
                self?.assingBlogDetail(blogDetails: blogDetail)
                
               
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
        self.postDetails = blogDetails
        self.blogName.text = blogDetails.message?.blogTitle
        if let convertedDate = convertDateFormat(inputDate: blogDetails.message?.createDate ?? "")as? String {
            self.blogDate.text = convertedDate
        }
        
        if let blogText = blogDetails.message?.blogText?.htmlAttributed(family: "Segoe UI", size: 15, color: .red){
            self.blogDescribtion.attributedText = blogText
        }
        blogDescribtion.adjustUITextViewHeight()
        self.likedbutton.setTitle((blogDetails.message?.likeCountText ?? "0") + " likes", for: .normal)
        let pwnerName = LocalStorage().getownerFirstName()
//        self.blogAuthor.text = "Dr. " + pwnerName
        if let url = URL(string: baseURLImage + (blogDetails.message?.blogFilePath ?? "")) {
//            self.blogDetailImage.load(url: url)
            self.blogDetailImage.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar"))

        }
    }
    
    func sharePostTapped() {
        shareButton.rx.tap.subscribe { [weak self] _ in
            self?.sharePost()
        } .disposed(by: self.disposeBag)
    }
    
    func sharePost() {
        if let message = postDetails?.message?.blogTitle {
            if let link = URL(string: baseURLImage + (postDetails?.message?.blogFilePath ?? "")) {
            print(link, "links")
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
           }
        }
    }
    
    func backview() {
        backButton.rx.tap.subscribe { [weak self] _  in
            self?.articleDetailsViewModel.backNavigationview()
        }.disposed(by: self.disposeBag)

    }
    
    

//    @IBAction func searchOrderAction(_ sender: UITextField) {
//        if  let searchText = sender.text {
//            guard let sections = try? articleDetailsViewModel.ordersInstance.value() else { return  }
//            guard let sectionsTemp = try? articleDetailsViewModel.ordersInstanceTemp.value() else { return  }
//            var filterArr = (sections.filter({(($0.orderNo)!.localizedCaseInsensitiveContains(searchText) || ($0.patientName)!.localizedCaseInsensitiveContains(searchText))}))
//
//            if filterArr.count > 0 {
//                articleDetailsViewModel.ordersInstance.onNext(filterArr)
//            }
//            else {
//                filterArr.removeAll()
//                articleDetailsViewModel.ordersInstance.onNext(filterArr)
//                showToast(LocalizedStrings().emptySearchData)
//
//            }
//
//            if searchText == "" {
//                filterArr.removeAll()
//                articleDetailsViewModel.ordersInstance.onNext(sectionsTemp)
//            }
//            self.tableView.reloadData()
//        }
//    }
}


extension BlogDetailsViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
