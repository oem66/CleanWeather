//
//  NetworkMonitor.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 14. 6. 2024..
//

import Foundation
import Network

final class NetworkMonitor: ObservableObject {
    @Published private(set) var isConnected = false
    @Published private(set) var isExpensive = false
    @Published private(set) var isConstrained = false
    @Published private(set) var connectionType = NWInterface.InterfaceType.other
    
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    
    init() {
        start()
    }
    
    private func start() {
        networkMonitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                self.isExpensive = path.isExpensive
                self.isConstrained = path.isConstrained
                
                let connectionTypes: [NWInterface.InterfaceType] = [.cellular, .wifi, .wiredEthernet]
                self.connectionType = connectionTypes.first(where: path.usesInterfaceType) ?? .other
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
    
    func stop() {
        networkMonitor.cancel()
    }
}
