//
//  NetworkService.swift
//  NatifeTask7
//
//  Created by Nazar on 24.04.2026.
//

import Alamofire
import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case requestFailed(statusCode: Int)
    case noInternet
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return ErrorText.invalidURL
        case .requestFailed(let statusCode):
            return "\(ErrorText.requestFailed): \(statusCode)"
        case .noInternet:
            return ErrorText.noInternet
        }
    }
}

protocol NetworkServiceProtocol {
    func request<T: Decodable>(from endPoint: any Endpoint) async throws -> T
}

nonisolated final class NetworkService: NetworkServiceProtocol {
    func request<T: Decodable>(from endpoint: any Endpoint) async throws -> T {
        let request = try endpoint.urlRequest()
        let result = await AF.request(request)
            .validate(statusCode: 200..<300)
            .serializingDecodable(T.self)
            .result
        
        switch result {
        case .success(let value): return value
        case .failure(let error):
            if let urlError = error.underlyingError as? URLError,
               urlError.code == .notConnectedToInternet {
                throw NetworkError.noInternet
            }
            throw NetworkError.requestFailed(statusCode: error.responseCode ?? 0)
        }
    }
}

private extension NetworkError {
    enum ErrorText {
        static let invalidURL = "Invalid URL"
        static let requestFailed = "Server error"
        static let noInternet = FilmsListTextError.internetError
    }
}
