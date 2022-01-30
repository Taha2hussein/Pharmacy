//
//  EditProfileViewController.swift
//  Pharmacy
//
//  Created by A on 30/01/2022.
//

import UIKit
import RxCocoa
import RxRelay
import RxSwift

class EditProfileViewController: BaseViewController {
    
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var ownerPhone: UILabel!
    @IBOutlet weak var ownerEmail: UILabel!
    @IBOutlet weak var ownerGender: UILabel!
    @IBOutlet weak var ownerJob: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var branchTableView: UITableView!
    
    var articleDetailsViewModel = EditProfileViewModel()
    private var router = EditProfileRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        setUP()
        articleDetailsViewModel.getPhofile()
        bindBranchToTableView()
        subsribeToProfile()
        subscribeToLoader()
        back()
    }
    
    func setUP() {
        self.branchTableView.estimatedRowHeight = 100
        self.branchTableView.rowHeight = UITableView.automaticDimension
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
    
    func bindBranchToTableView() {
        articleDetailsViewModel.ProfileBranch
            .bind(to: self.branchTableView
                    .rx
                    .items(cellIdentifier: String(describing:  EditProfileTableViewCell.self),
                           cellType: EditProfileTableViewCell.self)) { row, model, cell in
                cell.setData( product:model)
                
            }.disposed(by: self.disposeBag)
    }
    
    func subsribeToProfile() {
        articleDetailsViewModel.ProfileObject.subscribe { [weak self] profile in
            DispatchQueue.main.async {
            self?.setData(profile: profile)
            }
        } .disposed(by: self.disposeBag)

    }
    
    func back() {
        backbutton.rx.tap.subscribe { [weak self] _ in
            self?.articleDetailsViewModel.backNavigationview()
        }.disposed(by: self.disposeBag)

    }
    
    func setData(profile: ProfileModel) {
        self.ownerName.text = profile.message?.nameLocalized
        self.ownerJob.text = profile.message?.typeLocalized
        self.ownerEmail.text = profile.message?.email
        self.ownerPhone.text = profile.message?.mobileNumber
        let gender = profile.message?.gender
    
        (gender == 1) ? (self.ownerGender.text = "Female") : (self.ownerGender.text = "Male")
        setImage(image: profile.message?.image ?? "")
      
    }
    
    func setImage(image: String) {
        if let url = URL(string: baseURLImage + (image)) {
            self.ownerImage.load(url: url)
        }
    }
}

extension EditProfileViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
