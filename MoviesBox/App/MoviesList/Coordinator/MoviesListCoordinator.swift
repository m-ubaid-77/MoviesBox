//
//  MoviesListCoordinator.swift
//  MoviesBox
//
//  Created by Muhammad Ubaid on 05/08/2021.
//

import UIKit
import RxSwift

class MoviesListCoordinator: BaseCoordinator {
    private let disposeBag = DisposeBag()

    override func start() {
        let viewController = UIStoryboard.init(name: "Movies", bundle: nil).instantiateInitialViewController()
        guard let moviesListViewController = viewController as? MoviesListViewController else { return }

        // Coordinator initializes and injects viewModel
        let moviesListViewModel = MoviesListViewModel(moviesService: MoviesService())
        moviesListViewController.viewModel = moviesListViewModel

        // Coordinator subscribes to events and notifies parentCoordinator


        navigationController.viewControllers = [moviesListViewController]
    }
}
