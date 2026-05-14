//
//  PosterAssembly.swift
//  NatifeTask7
//
//  Created by Nazar on 06.05.2026.
//

import UIKit

final class PosterAssembly {
    static func build(poster: URL?) -> UIViewController {
        let viewController = PosterViewController()
        let viewStateFactory = PosterViewStateFactory()
        let router = PosterRouter(viewController: viewController)
        let presenter = PosterPresenter(
            poster: poster,
            viewController: viewController,
            viewStateFactory: viewStateFactory,
            router: router
        )

        viewController.inject(presenter: presenter)
        
        return viewController
    }
}
