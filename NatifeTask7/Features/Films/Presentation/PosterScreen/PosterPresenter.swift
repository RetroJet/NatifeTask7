//
//  PosterPresenter.swift
//  NatifeTask7
//
//  Created by Nazar on 06.05.2026.
//

import Foundation

protocol PosterPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSwipeDown()
    func didTapClose()
}

final class PosterPresenter {
    
    // MARK: - Properties
    
    private weak var viewController: PosterViewControllerProtocol?
    private let poster: URL?
    private let viewStateFactory: PosterViewStateFactoryProtocol
    private let router: PosterRouterProtocol
    
    // MARK: - Initialization
    
    init(
        poster: URL?,
        viewController: PosterViewControllerProtocol,
        viewStateFactory: PosterViewStateFactoryProtocol,
        router: PosterRouterProtocol
    ) {
        self.poster = poster
        self.viewController = viewController
        self.viewStateFactory = viewStateFactory
        self.router = router
    }
}

// MARK: - PosterPresenterProtocol

extension PosterPresenter: PosterPresenterProtocol {
    func viewDidLoad() {
        let viewState = viewStateFactory.make(poster: poster)
        viewController?.render(viewState)
    }
    
    func didSwipeDown() {
        router.dismiss()
    }
    
    func didTapClose() {
        router.dismiss()
    }
}
