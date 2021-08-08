//
//  MoviesListViewModel.swift
//  MoviesBox
//
//  Created by Muhammad Ubaid on 05/08/2021.
//

import Foundation
import RxSwift
import RxCocoa

class MoviesListViewModel {
    
    private let moviesService: MoviesService
    private let searchDataManager = SearchedDataStorageManager.shared
    private let disposeBag = DisposeBag()
    
    var query = "batman"
    var page = 0
    var totalPages = 0
    var searchQuery: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    let movies: BehaviorSubject<[Movie]> = BehaviorSubject(value: [])
    
    let loadMore: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    let isLoading = BehaviorSubject<Bool>(value: false)
    
    let noDataError = BehaviorSubject<[String:String]>(value: [:])
    //var isLoading = false
    
    let searchedQueries: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    
    init(moviesService: MoviesService) {
        self.moviesService = moviesService
        
        loadMore.subscribe { [weak self] (value) in
            
            guard let self = self else {return}
            
            if try! self.isLoading.value() == false && self.page < self.totalPages {
                self.isLoading.onNext(true)
                print("Load more itms")
                
                self.fetchMovies(query: try! self.searchQuery.value(), page: self.page+1, completion: nil)
            }
        }.disposed(by: disposeBag)
        
        searchQuery.subscribe { [weak self]  (queryValue) in
            guard let self = self else {return}
            if try! self.isLoading.value() == false && !(try! self.searchQuery.value()).isEmpty {
                self.isLoading.onNext(true)
                print("Load search itms")
                self.fetchMovies(query: queryValue.element!, page: 1) { [weak self] (status, querySearched) in
                    guard let self = self else {return}
                    if status {
                        self.searchDataManager.save(model: StoredSearchedData(query: querySearched))
                    } else {
                        self.noDataError.onNext(["title":"No Data", "message":"No data found for \"\(querySearched)\""])
                    }
                }
            }
            
            
        }.disposed(by: disposeBag)
    }

    
    func fetchMovies(query:String, page:Int, completion: ((Bool,String)->Void)?) {
        
        self.moviesService.getMovies(page: page, query: query) { [weak self](statusCode, moviesList) in
            print("moviesList : \(moviesList)")
            if let newMovies = moviesList.movies,newMovies.count > 0, let self = self {
                
                self.page = moviesList.page!
                self.totalPages = moviesList.total_pages!
                if self.page > 1 {
                    let newValue =  try! self.movies.value() + newMovies
                    self.movies.onNext(newValue)
                } else {
                    self.movies.onNext(newMovies)
                }
                completion?(true,query)
            } else {
                self?.movies.onNext([])
                completion?(false,query)
            }
            self?.isLoading.onNext(false)
            
        } failure: { (error) in
            print(" Error CCCCC : \(error)")
            self.isLoading.onNext(false)
            completion?(false,query)
            self.noDataError.onNext(["title":"Error", "message":error])
        }
        
    }
    
    func fetchSearchedQueries() {
        
        print("Fetch searched queries")
        
        let searchedData = searchDataManager.getSearchedData()
        searchedQueries.onNext(searchedData)
    }
}
