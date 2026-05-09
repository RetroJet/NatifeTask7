//
//  NetworkMonitor.swift
//  NatifeTask7
//
//  Created by Nazar on 06.05.2026.
//

import Network

protocol NetworkMonitorProtocol {
    var isConnected: Bool { get }
}

final class NetworkMonitor: NetworkMonitorProtocol {
    
    // MARK: - Properties
    
    private let monitor = NWPathMonitor()
    private(set) var isConnected = true
    
    // MARK: - Initialization
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: .global())
    }
}
