//
//  FilmsEndpoint.swift
//  NatifeTask7
//
//  Created by Nazar on 29.04.2026.
//

import Alamofire
import Foundation

enum FilmsEndpoint: Endpoint {
    case popular(page: Int)
    
    var path: String {
        switch self {
        case .popular: return API.popularFilms
        }
    }
    
    var method: HTTPMethod { .get }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .popular(let page):
            return [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        }
    }
}

private extension FilmsEndpoint {
    enum API {
        static let popularFilms = "/movie/popular"
    }
}
