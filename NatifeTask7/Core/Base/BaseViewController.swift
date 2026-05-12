//
//  BaseViewController.swift
//  NatifeTask7
//
//  Created by Nazar on 12.05.2026.
//

import UIKit

class BaseViewController<Presenter>: UIViewController {
    
    // MARK: - Properties
    
   private(set) var presenter: Presenter!
    
    func inject(presenter: Presenter) {
        self.presenter = presenter
    }
}
