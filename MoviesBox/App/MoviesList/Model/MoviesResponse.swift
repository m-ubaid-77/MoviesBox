//
//  MoviesResponse.swift
//  MoviesBox
//
//  Created by Muhammad Ubaid on 08/08/2021.
//

import ObjectMapper

struct MoviesResponse: Mappable{
    var page: Int?
    var movies: [Movie]?
    var total_pages: Int?
    var total_results: Int?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        movies <- map["results"]
        page <- map["page"]
        total_pages <- map["total_pages"]
        total_results <- map["total_results"]
    }
}
