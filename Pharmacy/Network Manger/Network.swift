//
//  Network.swift
//  MachhineTest
//
//  Created by A on 24/12/2021.
//


import Foundation
import Alamofire

enum InternetErro: Int {
    case error = 500
}

class NetWorkManager {
    
    static let instance = NetWorkManager()
    func API<T: Codable>( userImage: Data? = nil, method: HTTPMethod, url: String, parameters:[String:Any]? = nil, header: [String:String]?  = nil, completion: @escaping (_ error: Error?, _ status: Int?, _ response: T?)->Void) {
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.methodDependent, headers: header)
            .responseJSON { res -> Void in
                switch res.result
                {
                case .failure(let error):
                    completion(error,nil,nil)
                case .success(_):
                    if let dict = res.result.value as? Dictionary<String, Any> {
                        guard let status = dict["successtate"] as? Int else{return}
                        do{
                            guard let data = res.data else { return }
                            let response = try JSONDecoder().decode(T.self, from: data)
                            completion(nil,status,response)
                        }catch let err{
                            print("Error In Decode Data \(err.localizedDescription)")
                            completion(err,InternetErro.error.rawValue,nil)
                        }
                    }
                    else{
                        completion(nil,InternetErro.error.rawValue,nil)
                    }
                }
            }
        
    }
    
}
