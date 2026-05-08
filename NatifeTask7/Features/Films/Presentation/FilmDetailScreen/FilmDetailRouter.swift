//
//  FilmDetailRouter.swift
//  NatifeTask7
//
//  Created by Nazar on 06.05.2026.
//

import UIKit

protocol FilmDetailRouterProtocol: AnyObject {
    func openTrailer(_ key: String)
}

final class FilmDetailRouter {}

extension FilmDetailRouter: FilmDetailRouterProtocol {
    func openTrailer(_ key: String) {
        guard let url = URL(string: "\(YouTube.baseURL)\(key)") else { return }
        UIApplication.shared.open(url)
    }
}

private extension FilmDetailRouter {
    enum YouTube {
            static let baseURL = "https://www.youtube.com/watch?v="
        }
}
