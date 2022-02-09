//
//  BlogViewModel.swift
//  Pharmacy
//
//  Created by A on 03/02/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import SwiftUI

class BlogViewModel{
    
    private weak var view: BlosgViewController?
    private var router: BlogRouter?
    var  state = State()
    var Blogs = PublishSubject<[BlogMessage]>()
    var blogsSearched = PublishSubject<[BlogMessage]>()
    var likeBlogs = PublishSubject<LikeBlogModel>()
    var toogleLikeIcon = BehaviorRelay<Bool>(value: false)
    
    func bind(view: BlosgViewController, router: BlogRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    
    func getBlogs(blogCountPerPage: Int) {
        let parameters = ["PageRows": blogCountPerPage]
        var request = URLRequest(url: URL(string: bligsListApi )!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        request.httpBody = jsonString?.data(using: .utf8)
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        state.isLoading.accept(true)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                var blog = BlogsList()
                blog = try decoder.decode(BlogsList.self, from: data)
                print(blog , "profile")
                if blog.successtate == 200 {
                    
                    self.Blogs.onNext(blog.message ?? [])
                }
                
                else {
                    Alert().displayError(text: blog.errormessage ?? "An error occured , Please try again", viewController: self.view!)
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
    
    
    // like blogs
    func likeBlog(blogID: Int) {
        var request = URLRequest(url: URL(string: likeBlogApi  + "?id=\(blogID)")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        state.isLoading.accept(true)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                var blog = LikeBlogModel()
                blog = try decoder.decode(LikeBlogModel.self, from: data)
                if blog.successtate == 200 {
                    self.toogleLikeIcon.accept(true)
                    self.likeBlogs.onNext(blog)
                }
                
                else {
                    Alert().displayError(text: blog.errormessage ?? "An error occured , Please try again", viewController: self.view!)
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
    // unlike
    func unlikeBlog(blogID: Int) {
        var request = URLRequest(url: URL(string: unlikeBlogApi  + "?id=\(blogID)")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let key = LocalStorage().getLoginToken()
        let authValue: String? = "Bearer \(key)"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        state.isLoading.accept(true)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            self.state.isLoading.accept(false)
            do {
                
                let decoder = JSONDecoder()
                var blog = LikeBlogModel()
                blog = try decoder.decode(LikeBlogModel.self, from: data)
                if blog.successtate == 200 {
                    self.toogleLikeIcon.accept(false)
                    self.likeBlogs.onNext(blog)
                }
                
                else {
                    Alert().displayError(text: blog.errormessage ?? "An error occured , Please try again", viewController: self.view!)
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
