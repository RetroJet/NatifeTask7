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
    
    var baseURL: URL {
        guard let url = URL(string: API.baseURL) else { fatalError(ErrorText.invalidURL) }
        return url
    }
    
    var path: String {
        switch self {
        case .popular: return API.popularFilms
        }
    }
    
    var method: HTTPMethod { .get }
    
    var headers: [String: String] {
        [
            "Authorization": "Bearer \(APIConfig.tmdbAPIKey)",
            "accept": "application/json"
        ]
    }
    
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
        static let baseURL = "https://api.themoviedb.org/3"
        static let popularFilms = "/movie/popular"
    }
    
    enum ErrorText {
        static let invalidURL = "Invalid base URL"
    }
}
