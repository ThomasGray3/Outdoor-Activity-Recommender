//
//  Network manager.swift
//  Wild Route
//
//  Created by THOMAS GRAY on 26/02/2021.
//

import Foundation
import Network

final class NetworkMonitor: NSObject, ObservableObject {
    @Published var monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "monitor")
    
    @Published var connected = true
    
    override init() {
        super.init()
        self.monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.connected = path.status == .satisfied ? true : false
            }
        }
        self.monitor.start(queue: queue)
    }
}

