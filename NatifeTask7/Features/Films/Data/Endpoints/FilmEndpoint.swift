//
//  FilmEndpoint.swift
//  NatifeTask7
//
//  Created by Nazar on 05.05.2026.
//

import Alamofire
import Foundation

enum FilmEndpoint: Endpoint {
    case detail(id: Int)
    case trailer(id: Int)
    
    var path: String {
        switch self {
        case .detail(let id): 
            return "/movie/\(id)"
        case .trailer(let id): 
            return "/movie/\(id)/videos"
        }
    }
    
    var method: Alamofire.HTTPMethod { .get }
    
    var queryItems: [URLQueryItem] {
        return [URLQueryItem(name: "language", value: "en-US")]
    }
}
