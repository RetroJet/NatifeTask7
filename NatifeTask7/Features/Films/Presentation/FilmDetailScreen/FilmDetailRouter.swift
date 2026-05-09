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
        guard let url = URL(string: "\(YouTube.baseURL)\(key)") else { return }
        UIApplication.shared.open(url)
    }
    
    func openPoster(_ poster: URL?) {
        let posterViewController = PosterAssembly.build(poster: poster)
        posterViewController.modalPresentationStyle = .fullScreen
        self.viewController?.present(posterViewController, animated: true)
    }
}

private extension FilmDetailRouter {
    enum YouTube {
            static let baseURL = "https://www.youtube.com/watch?v="
        }
}
