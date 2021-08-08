//
//  SearchData.swift
//  MoviesBox
//
//  Created by Muhammad Ubaid on 06/08/2021.
//

import Foundation
import RealmSwift

class StoredSearchedData: Object {
    
    @objc dynamic var query = ""
    @objc dynamic var dateAdded = Int64(Date().timeIntervalSince1970)

    override static func primaryKey() -> String? {
        return "query"
    }

    convenience init(query: String) {
        self.init()
        self.query = query
    }

    convenience init(query: String, dateCreated: Int64) {
        self.init()
        self.query = query
        self.dateAdded = dateCreated
    }

}

