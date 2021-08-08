//
//  Movie.swift
//  MoviesBox
//
//  Created by Muhammad Ubaid on 08/08/2021.
//

import ObjectMapper

struct Movie: Mappable{
    var original_title: String?
    var overview: String?
    var poster_path: String?
    var release_date: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        original_title <- map["original_title"]
        overview <- map["overview"]
        poster_path <- map["poster_path"]
        release_date <- map["release_date"]
    }
}
