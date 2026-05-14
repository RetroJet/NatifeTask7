//
//  FilmDetailAssembly.swift
//  NatifeTask7
//
//  Created by Nazar on 05.05.2026.
//

import UIKit

final class FilmDetailAssembly {
    static func build(container: DIContainerProtocol, filmId: Int, title: String) -> UIViewController {
        let viewController = FilmDetailViewController()
        let viewStateFactory = FilmDetailViewStateFactory()
        let router = FilmDetailRouter(viewController: viewController)
        let presenter = FilmDetailPresenter(
            filmId: filmId,
            title: title,
            dataRepository: container.getFilmsDataRepository(),
            viewStateFactory: viewStateFactory,
            viewController: viewController,
            router: router
        )
        viewController.inject(presenter: presenter)
        
        return viewController
    }
}
