//
//  BlogDetailsViewModel.swift
//  Pharmacy
//
//  Created by taha hussein on 12/02/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class BlogDetailsViewModel {
    
    private weak var view: BlogDetailsViewController?
    private var router: BlogDetailsRouter?
    var blogDetails : Int?
    var blogDetailsObject = PublishSubject<BlogDetailsModel>()
    var state = State()
    func bind(view: BlogDetailsViewController, router: BlogDetailsRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func getBlogDetails() {
        var request = URLRequest(url: URL(string: blogDetailsApi  + "?id=\(blogDetails ?? 0)")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        request.setValue(getCurrentLanguage(), forHTTPHeaderField: "lang")
        state.isLoading.accept(true)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                var blogDetails: BlogDetailsModel!
                blogDetails = try decoder.decode(BlogDetailsModel.self, from: data)
                print(blogDetails, "blogDetailsblogDetails")
                if blogDetails.successtate == 200 {
                    self.blogDetailsObject.onNext(blogDetails)
                }
                
                else {
                    DispatchQueue.main.async {
                        Alert().displayError(text: blogDetails.errormessage ?? "An error occured , Please try again".localized, viewController: self.view!)
                    }
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}

extension BlogDetailsViewModel: backView {
    func backNavigationview() {
        router?.backView()
    }
    
    
}
