//
//  FilmsListAssembly.swift
//  NatifeTask7
//
//  Created by Nazar on 27.04.2026.
//

import UIKit

final class FilmsListAssembly {
    static func build(container: DIContainerProtocol) -> UIViewController {
        let viewController = FilmsListViewController()
        let viewStateFactory = FilmsListViewStateFactory()
        let router = FilmsListRouter(
            viewController: viewController
        ) { filmId, title in
                FilmDetailAssembly.build(container: container, filmId: filmId, title: title)
        }
        let presenter = FilmsListPresenter(
            viewController: viewController,
            viewStateFactory: viewStateFactory,
            dataRepository: container.getFilmsDataRepository(),
            router: router
        )
        
        viewController.inject(presenter: presenter)
        
        return viewController
    }
}
