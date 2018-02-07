//
//  BLEPeerManager.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 11/05/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol BLEPeerManagerDelegate {
    func didUpdateState(state: CBManagerStatus)
    func didStartAdvertising()
}

class BLEPeerManager: NSObject {
    
    private static var manager: BLEPeerManager!
    static var instance: BLEPeerManager {
        get {
              if manager == nil {
                manager = BLEPeerManager()
                return manager
              } else {
                //manager.peerManager.delegate = manager
                return manager
            }
        }
    }
    
    var blePeerManagerDelegate:BLEPeerManagerDelegate?
    private var peerManager : [String: CBPeripheralManager] = [:]
    
    override init() {
        super.init()
    }
    
    open func addService(services: [CBMutableService], peerManager: CBPeripheralManager) {
        for item in services {
            peerManager.add(item)
        }
    }
}
