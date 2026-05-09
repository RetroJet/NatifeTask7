//
//  FilmDetailRouter.swift
//  NatifeTask7
//
//  Created by Nazar on 06.05.2026.
//

import UIKit

protocol FilmDetailRouterProtocol: AnyObject {
    func openTrailer(_ key: String)
    func openPoster(_ poster: URL?)
}

final class FilmDetailRouter {
    weak var viewController: UIViewController?
}

extension FilmDetailRouter: FilmDetailRouterProtocol {
    func openTrailer(_ key: String) {
        let trailerViewController = TrailerViewController(key: key)
        viewController?.present(trailerViewController, animated: true)
    }
    
    func openPoster(_ poster: URL?) {
        let posterViewController = PosterAssembly.build(poster: poster)
        posterViewController.modalPresentationStyle = .overFullScreen
        self.viewController?.present(posterViewController, animated: true)
    }
}
