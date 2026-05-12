//
//  EndPoint.swift
//  NatifeTask7
//
//  Created by Nazar on 29.04.2026.
//

import Alamofire
import Foundation

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var baseURL: URL {
        guard let url = URL(string: APIConfig.baseURL) else {
            fatalError(NetworkError.invalidURL.localizedDescription)
        }
        return url
    }
    
    var headers: [String: String] {
        [
            "Authorization": "Bearer \(APIConfig.tmdbAPIKey)",
            "accept": "application/json"
        ]
    }
    
    func urlRequest() throws -> URLRequest {
        guard var components = URLComponents(string: baseURL.absoluteString + path) else {
            throw NetworkError.invalidURL
        }
        
        components.queryItems = queryItems
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpMethod = method.rawValue
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        return request
    }
}
