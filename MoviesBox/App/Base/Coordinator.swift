//
//  Coordinator.swift
//  MoviesBox
//
//  Created by Muhammad Ubaid on 05/08/2021.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get set }
    
    func start()
    func start(coordinator: Coordinator)
    func didFinish(coordinator: Coordinator)
}
