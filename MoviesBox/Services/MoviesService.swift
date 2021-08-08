//
//  MoviesService.swift
//  MoviesBox
//
//  Created by Muhammad Ubaid on 05/08/2021.
//

import Foundation

class MoviesService {
    
    func getMovies(page:Int, query:String,success: @escaping (Int, MoviesResponse) -> (), failure: @escaping (String) -> ()) {
        
        APIClient.shared.get(urlString: APIManager.baseURL+APIManager.moviesEndPoint, parameters: ["api_key":APIManager.APIKey,"query":query,"page":page]) { (code, movies) in
            success(code,movies)
        } failure: { (error) in
            failure(error)
        }
    }
}
