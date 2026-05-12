//
//  DIContainer.swift
//  NatifeTask7
//
//  Created by Nazar on 27.04.2026.
//

protocol DIContainerProtocol {
    func getFilmsDataRepository() -> any FilmsDataRepositoryProtocol
}

final class DIContainer {
    
    // MARK: - Properties
    
    private let networkService: any NetworkServiceProtocol
    private let dataRepository: any FilmsDataRepositoryProtocol
    private let networkMonitor: any NetworkMonitorProtocol
    
    // MARK: - Initialization
    
    init() {
        self.networkMonitor = NetworkMonitor()
        self.networkService = NetworkService(networkMonitor: networkMonitor)
        self.dataRepository = FilmsDataRepository(networkService: networkService)
    }
}

// MARK: - DIContainerProtocol

extension DIContainer: DIContainerProtocol {
    func getFilmsDataRepository() -> any FilmsDataRepositoryProtocol { dataRepository }
}
