//
//  DIContainer.swift
//  NatifeTask7
//
//  Created by Nazar on 27.04.2026.
//

protocol DIContainerProtocol {
    func getDataRepository() -> any DataRepositoryProtocol
    func getNetworkMonitor() -> any NetworkMonitorProtocol
}

final class DIContainer {
    
    // MARK: - Properties
    
    private let networkService: any NetworkServiceProtocol
    private let dataRepository: any DataRepositoryProtocol
    private let networkMonitor: any NetworkMonitorProtocol
    
    // MARK: - Initialization
    
    init() {
        self.networkService = NetworkService()
        self.dataRepository = DataRepository(networkService: networkService)
        self.networkMonitor = NetworkMonitor()
    }
}

// MARK: - DIContainerProtocol

extension DIContainer: DIContainerProtocol {
    func getDataRepository() -> any DataRepositoryProtocol { dataRepository }
    func getNetworkMonitor() -> any NetworkMonitorProtocol { networkMonitor }
}
