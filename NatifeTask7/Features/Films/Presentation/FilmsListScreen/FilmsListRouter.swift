//
//  FilmsListRouter.swift
//  NatifeTask7
//
//  Created by Nazar on 05.05.2026.
//

import UIKit

protocol FilmsListRouterProtocol: AnyObject {
    func openFilmDetail(_ filmId: Int)
}

final class FilmsListRouter {
    
    // MARK: - Properties
    
    weak var viewController: UIViewController?
    private let container: any DIContainerProtocol
    
    // MARK: - Initialization
    
    init(container: any DIContainerProtocol) {
        self.container = container
    }
}

// MARK: - FilmsListRouterProtocol

extension FilmsListRouter: FilmsListRouterProtocol {
    func openFilmDetail(_ filmId: Int) {
        //let filmDetailViewController = 
    }
}
