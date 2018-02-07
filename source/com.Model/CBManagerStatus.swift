//
//  CBManagerStatus.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 02/08/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import CoreBluetooth

enum CBManagerStatus: Int {
    case unknown = 0
    case resetting = 1
    case unsupported = 2
    case unauthorized = 3
    case poweredOff = 4
    case poweredOn = 5
    
    @available(iOS 10.0, *)
    static func getStatus(state: CBManagerState) -> CBManagerStatus {
        switch state {
            case .unknown:
                return .poweredOff
            case .resetting:
                return .resetting
            case .unsupported:
                return .unsupported
            case .unauthorized:
                return .unauthorized
            case .poweredOff:
                return .poweredOff
            case .poweredOn:
                return .poweredOn
        }
    }
}
