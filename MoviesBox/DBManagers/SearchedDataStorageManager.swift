//
//  SearchedDataStorageManager.swift
//  MoviesBox
//
//  Created by Muhammad Ubaid on 06/08/2021.
//

import Foundation
import RealmSwift

class SearchedDataStorageManager: NSObject {

    static let shared = SearchedDataStorageManager()
    
    private let queue = DispatchQueue(label: "com.moviesbox.\(String(describing: SearchedDataStorageManager.self))", qos: .userInteractive)
    private var database: Realm
    
    private override init() {
        database = try! Realm()
        print("SearchedDataStorageManager Realm Path", database.configuration.fileURL?.path)
        super.init()
        queue.sync { [weak self] in
            self?.database = try! Realm(queue: self?.queue)
        }
    }
    
    func save(model: StoredSearchedData) {
        queue.async { [weak self] in
            self?.database.beginWrite()
            self?.database.add(model, update: .modified)
            try! self?.database.commitWrite()
        }
    }
    
    func getSearchedData() -> [String] {
        queue.sync { [unowned self] in

            let storedSeachedData = Array(database.objects(StoredSearchedData.self).sorted(byKeyPath: "dateAdded", ascending: false))
            
            var dataArray = [String]()
            
            storedSeachedData.prefix(20).forEach { (data) in
                let searchedData = data.query
                dataArray.append(searchedData)
            }

            return dataArray
        }
    }
}
