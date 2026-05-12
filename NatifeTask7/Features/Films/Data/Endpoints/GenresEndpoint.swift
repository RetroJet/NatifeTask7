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
    
    var path: String {
        switch self {
        case .genres:
            return Constant.API.genresFilm
        }
    }
    
    var method: Alamofire.HTTPMethod { .get }
    
    var queryItems: [URLQueryItem] { [] }
}

private extension GenresEndpoint {
    enum Constant {
        enum API {
            static let genresFilm = "/genre/movie/list"
        }
    }
}
