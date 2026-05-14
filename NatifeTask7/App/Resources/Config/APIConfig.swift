//
//  APIConfig.swift
//  NatifeTask7
//
//  Created by Nazar on 05.05.2026.
//

import Foundation

enum APIConfig {
    static let baseURL = "https://api.themoviedb.org/3"
    
    static var tmdbAPIKey: String {
        guard
            let path = Bundle.main.path(forResource: "Environment", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path),
            let key = dict[Constant.API.key] as? String
        else {
            fatalError(Constant.ErrorText.wrongKey)
        }
        return key
    }
}

private extension APIConfig {
    enum Constant {
        enum API {
            static let key = "TMDB_API_KEY"
        }
        
        enum ErrorText {
            static let wrongKey = "TMDB_API_KEY not found"
        }
    }
}
