//
//  AppCoordinator.swift
//  MoviesBox
//
//  Created by Muhammad Ubaid on 05/08/2021.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    
    private var window : UIWindow?
    
    init(window:UIWindow?) {
        self.window = window
    }
    
    override func start() {
        
        navigationController.navigationBar.isHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        // TODO: here you could check if user is signed in and show appropriate screen
        let coordinator = MoviesListCoordinator()
        coordinator.navigationController = navigationController
        start(coordinator: coordinator)
    }
}
