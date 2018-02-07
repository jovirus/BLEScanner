//
//  DeviceConnectionType.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 20/04/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation

public enum DeviceConnectionType: Int {
    case non_connectable = 0
    case connectable = 1
    
    func description() -> String {
        switch self {
        case .connectable:
            return "Connectable"
        case .non_connectable:
            return "Non-connectable"
        }
    }
}
