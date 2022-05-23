//
//  AlamofireMultipart.swift
//  Roaya
//
//  Created by mohab on 3/3/20.
//  Copyright © 2020 panorama. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class AlamofireMultiPart{
    
    static func PostMultiWithModel<T: Codable>(model :T.Type , url: String, Images: [UploadDataa]?,header:[String:Any]?, parameters:[String: Any]?, completion: @escaping (ServerResponse<T>) -> Void) {
      upload(multipartFormData: { (multipartFromData) in
        if parameters != nil{
          for (key, value) in parameters! {
            multipartFromData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
          }
        }
        
        if let images = Images{
            for uploadData in images{
                print(uploadData.Key)
                multipartFromData.append(uploadData.data,
                                         withName: uploadData.Key,
                                         fileName: "\(Date().timeIntervalSince1970).jpg",
                                         mimeType: "image/jpeg")
            }
        }

      }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url , method: .post, headers: header as? HTTPHeaders) { (result) in
         
        switch result {
        case .failure(let error):
          print(error)
          completion(ServerResponse<T>.failure(error))
        case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
          upload.responseJSON(completionHandler: { (response) in
             
            switch response.result {
            case .success(let value):
               
               
               
              do {
                let decoder = JSONDecoder()
                let modules = try decoder.decode(model, from: response.data!)
                completion(ServerResponse<T>.success(modules))
              }catch {
                print("catch >>>>", error.localizedDescription)
                completion(ServerResponse<T>.failure(error))
              }
               
            case .failure(let error):
              print(error)
              completion(ServerResponse<T>.failure(error))
            }
          })
        }
      }
    }
    
    
}
enum ServerResponse<T> {
    case success(T), failure(Error?)
}
struct UploadDataa {
    var data : Data
    var Key : String
}

struct UploadDataURL {
    var data: URL
    var name: String
}
