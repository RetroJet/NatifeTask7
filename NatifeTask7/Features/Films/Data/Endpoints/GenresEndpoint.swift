//
//  GenresEndpoint.swift
//  NatifeTask7
//
//  Created by Nazar on 01.05.2026.
//

import Alamofire
import Foundation

enum GenresEndpoint: Endpoint {
    case genres
    
    var baseURL: URL {
        guard let url = URL(string: API.baseURL) else { fatalError(CommonTextError.invalidURL) }
        return url
    }
    
    var path: String {
        switch self {
        case .genres: return API.genresFilm
        }
    }
    
    var method: Alamofire.HTTPMethod { .get }
    
    var headers: [String: String] {
        [
            "Authorization": "Bearer \(APIConfig.tmdbAPIKey)",
            "accept": "application/json"
        ]
    }
    
    var queryItems: [URLQueryItem] { [] }
}

private extension GenresEndpoint {
    enum API {
        static let baseURL = "https://api.themoviedb.org/3"
        static let genresFilm = "/genre/movie/list"
    }
}
