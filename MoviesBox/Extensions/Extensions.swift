//
//  SearchData.swift
//  MoviesBox
//
//  Created by Muhammad Ubaid on 06/08/2021.
//

import PKHUD
import UIKit

extension UIViewController {
    
    func showProgress() {
        HUD.show(.progress)
    }
    
    func hideProgress() {
        HUD.hide()
    }
    
}

