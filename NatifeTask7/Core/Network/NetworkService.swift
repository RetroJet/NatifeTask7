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
            return Constant.TextError.invalidURL
        case .requestFailed(let statusCode):
            return "\(Constant.TextError.requestFailed): \(statusCode)"
        case .noInternet:
            return Constant.TextError.internetError
        }
    }
}

protocol NetworkServiceProtocol {
    func request<T: Decodable>(from endPoint: any Endpoint) async throws -> T
}

nonisolated final class NetworkService: NetworkServiceProtocol {
    private let networkMonitor: any NetworkMonitorProtocol
    
    init(networkMonitor: any NetworkMonitorProtocol) {
        self.networkMonitor = networkMonitor
    }
    
    func request<T: Decodable>(from endpoint: any Endpoint) async throws -> T {
        guard networkMonitor.isConnected else {
            throw NetworkError.noInternet
        }
        
        let request = try endpoint.urlRequest()
        let result = await AF.request(request)
            .validate(statusCode: 200..<300)
            .serializingDecodable(T.self)
            .result
        
        switch result {
        case .success(let value):
            return value
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
    enum Constant {
        enum TextError {
            static let requestFailed = "Server error"
            static let invalidURL = "Invalid base URL"
            static let internetError = String(localized: "common_internet_error")
        }
    }
}
