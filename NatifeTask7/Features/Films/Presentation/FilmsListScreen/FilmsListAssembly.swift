//
//  FilmsListAssembly.swift
//  NatifeTask7
//
//  Created by Nazar on 27.04.2026.
//

import UIKit

final class FilmsListAssembly {
    static func build(container: DIContainerProtocol) -> UIViewController {
        let router = FilmsListRouter(container: container)
        let viewController = FilmsListViewController()
        let viewStateFactory = FilmsListViewStateFactory()
        let presenter = FilmsListPresenter(
            viewController: viewController,
            viewStateFactory: viewStateFactory,
            dataRepository: container.getDataRepository(),
            router: router
        )
        
        router.viewController = viewController
        viewController.inject(presenter: presenter)
        
        return viewController
    }
}
