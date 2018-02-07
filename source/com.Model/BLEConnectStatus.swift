//
//  BLEConnectStatus.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 31/03/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import CoreBluetooth
public enum BLEConnectStatus: Int {
    case disconnected = 0
    case connecting = 1
    case connected = 3
    case disconnecting = 4
    
    func description() -> String {
        switch self {
        case .connecting:
            return "Connecting"
        case .connected:
            return "Connected"
        case .disconnecting:
            return "Disconnecting"
        case .disconnected:
            return "Disconnected"
        }
    }
    
    static func setStatus(status: CBPeripheralState) -> BLEConnectStatus {
        switch status
        {
            case .connecting:
                return BLEConnectStatus.connecting
            case .disconnected:
                return BLEConnectStatus.disconnected
            case .connected:
                return BLEConnectStatus.connected
            case .disconnecting:
                return BLEConnectStatus.disconnecting
        }
    }
}
