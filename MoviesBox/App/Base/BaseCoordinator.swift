//
//  BaseCoordinator.swift
//  MoviesBox
//
//  Created by Muhammad Ubaid on 05/08/2021.
//

import UIKit

class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController = UINavigationController()
    
    func start() {
        fatalError("Start method must be implemented")
    }
    
    func start(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func didFinish(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
