//
//  FilmsListRouter.swift
//  NatifeTask7
//
//  Created by Nazar on 05.05.2026.
//

import UIKit

protocol FilmsListRouterProtocol: AnyObject {
    func openFilmDetail(_ filmId: Int, title: String)
}

final class FilmsListRouter {
    
    // MARK: - Properties
    
    private weak var viewController: UIViewController?
    private let filmDetailFactory: (Int, String) -> UIViewController
    
    // MARK: - Initialization
    
    init(
        viewController: UIViewController,
        filmDetailFactory: @escaping (Int, String) -> UIViewController
    ) {
        self.viewController = viewController
        self.filmDetailFactory = filmDetailFactory
    }
}

// MARK: - FilmsListRouterProtocol

extension FilmsListRouter: FilmsListRouterProtocol {
    func openFilmDetail(_ filmId: Int, title: String) {
        let filmDetailViewController = filmDetailFactory(filmId, title)
        self.viewController?.navigationController?.pushViewController(filmDetailViewController, animated: true)
    }
}
