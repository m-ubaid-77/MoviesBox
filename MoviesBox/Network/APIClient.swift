//
//  ApiClient.swift
//  MoviesBox
//
//  Created by Muhammad Ubaid on 05/08/2021.
//

import Foundation
import RxAlamofire
import RxSwift
import ObjectMapper

class APIClient {
    
    static let shared = APIClient()
    
    internal required init() {
        
    }
    
    func get<T: BaseMappable>(urlString: String, parameters: [String: Any] = [:], success: @escaping (Int, T) -> (), failure: @escaping (String) -> ()) {
        
        let parameters = parameters
        
        guard let url = NSURL(string: urlString) else {
            return
        }
        
        let urlString = url.absoluteString!
        
        _ = request(.get,
                    urlString,
                    parameters: parameters,
                    headers: nil)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (response) in
                let statusCode = response.response?.statusCode
                let model = Mapper<T>().map(JSON: response.value as! [String : Any])
                success(statusCode!, model!)
            }, onError: { (error) in
                failure(error.localizedDescription)
            })
    }
}


