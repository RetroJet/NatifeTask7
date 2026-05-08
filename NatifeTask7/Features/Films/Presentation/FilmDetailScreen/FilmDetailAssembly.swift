//
//  FilmDetailAssembly.swift
//  NatifeTask7
//
//  Created by Nazar on 05.05.2026.
//

import UIKit

final class FilmDetailAssembly {
    static func build(container: DIContainerProtocol, filmId: Int, title: String) -> UIViewController {
        let router = FilmDetailRouter()
        let viewController = FilmDetailViewController()
        let viewStateFactory = FilmDetailViewStateFactory()
        let presenter = FilmDetailPresenter(
            filmId: filmId,
            title: title,
            viewController: viewController,
            dataRepository: container.getDataRepository(),
            viewStateFactory: viewStateFactory,
            router: router
        )
        
        viewController.inject(presenter: presenter)
        
        return viewController
    }
}
