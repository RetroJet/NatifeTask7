//
//  NetworkMonitor.swift
//  NatifeTask7
//
//  Created by Nazar on 06.05.2026.
//

import Network

protocol NetworkMonitorProtocol: Actor {
    var isConnected: Bool { get }
}

actor NetworkMonitor: NetworkMonitorProtocol {
    
    // MARK: - Properties
    
    private let monitor = NWPathMonitor()
    private(set) var isConnected = true
    
    // MARK: - Initialization
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { await self?.update(path.status == .satisfied) }
        }
        monitor.start(queue: .global())
    }
    
    private func update(_ connected: Bool) {
        isConnected = connected
    }
}
