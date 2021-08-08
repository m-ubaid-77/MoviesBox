//
//  MoviesListViewController.swift
//  MoviesBox
//
//  Created by Muhammad Ubaid on 05/08/2021.
//

import UIKit
import RxSwift
import RxCocoa

class MoviesListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchedDataTableView: UITableView!
    @IBOutlet weak var searchTableViewBottomConstraint: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    var viewModel: MoviesListViewModel!
    static let startLoadingOffset: CGFloat = 20.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        searchedDataTableView.tableFooterView = UIView()
        bindViews()
        viewModel.fetchMovies(query: "batman", page: 1, completion: nil)
    }
    
    func bindViews() {
        
        viewModel.movies
            .bind(to: tableView.rx.items(cellIdentifier: "MovieTableViewCell", cellType: MovieTableViewCell.self)) { (index, movie, cell) in
                cell.configureCell(movie: movie)
            }
            .disposed(by: disposeBag)
        
        let loadNextPageTrigger = tableView.rx.contentOffset
            .flatMap { offset in
                MoviesListViewController.isNearTheBottomEdge(contentOffset: offset, self.tableView)
                    ? Observable.just(true)
                    : Observable.empty()
            }
        
        loadNextPageTrigger.subscribe { (value) in
            self.viewModel.loadMore.onNext(value)
        }.disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked.subscribe { [weak self] (event) in
            
            guard let self = self else {return}
            self.searchBar.resignFirstResponder()
            self.searchedDataTableView.isHidden = true
            if let query = self.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), query.count > 1 {
                self.viewModel.searchQuery.onNext(query)
            }
            
        }.disposed(by: disposeBag)
        
        
        searchBar.rx.cancelButtonClicked.subscribe { [weak self] (event) in
            
            guard let self = self else {return}
            self.searchBar.resignFirstResponder()
            self.searchedDataTableView.isHidden = true
            
        }.disposed(by: disposeBag)
        
        viewModel.searchedQueries
            .bind(to: searchedDataTableView.rx.items(cellIdentifier: "SearchedQueryCell", cellType: UITableViewCell.self)) { (index, queryString, cell) in
                cell.textLabel?.text = queryString
            }
            .disposed(by: disposeBag)
        
        searchedDataTableView.rx.modelSelected(String.self)
            .map { $0 }
            .bind(to: rowSelectedTableView)
            .disposed(by: disposeBag)
        
        
        searchBar.rx.textDidBeginEditing
            .map { true }
            .bind(to: showsTableView)
            .disposed(by: disposeBag)
        
        let keyboardHeight = NotificationCenter.default.rx
            .notification(UIResponder.keyboardDidChangeFrameNotification)
            .map { notification -> CGFloat in
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
            }
        
        keyboardHeight
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self](keyboardHeight) in
                guard let self = self else {return}
                self.searchTableViewBottomConstraint.constant = keyboardHeight-self.view.safeAreaInsets.bottom
                self.view.layoutIfNeeded()
                print("Keyboard height : \(keyboardHeight) safre area insets : \(self.view.safeAreaInsets.bottom)")
            }).disposed(by: disposeBag)
        
        viewModel.isLoading
            .subscribe(onNext: { [weak self] isLoading in
                isLoading ? self?.showProgress() : self?.hideProgress()
            })
            .disposed(by: disposeBag)
        
        viewModel.noDataError.subscribe { [weak self] (value) in
            
            if let errorDetails = value.element, !errorDetails.isEmpty {
                let alert = UIAlertController(title: errorDetails["title"], message: errorDetails["message"], preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
            
        }.disposed(by: disposeBag)
    }
    
    
    static func isNearTheBottomEdge(contentOffset: CGPoint, _ tableView: UITableView) -> Bool {
        return contentOffset.y + tableView.frame.size.height + startLoadingOffset > tableView.contentSize.height
    }
}

extension MoviesListViewController{
    
    private var showsTableView: AnyObserver<Bool> {
        return Binder(self) { this, showsTableView in
            
            this.viewModel.fetchSearchedQueries()
            if try! this.viewModel.searchedQueries.value().count > 0, showsTableView {
                this.searchedDataTableView.isHidden = !showsTableView
            } else {
                this.searchedDataTableView.isHidden = true
            }
            
        }.asObserver()
    }
    
    private var rowSelectedTableView: AnyObserver<String> {
        return Binder(self) { this, selectedRowData in
            
            this.searchedDataTableView.isHidden = true
            this.viewModel.searchQuery.onNext(selectedRowData)
            this.searchBar.text = selectedRowData
            this.searchBar.resignFirstResponder()
        }.asObserver()
    }
}
