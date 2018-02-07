//
//  GattRole.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 31/03/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
public enum GattRole: Int{
    case gattService = 0
    case gattClient = 1
    case gattAdvertiser = 2
    
    func description() -> String {
        switch self {
            case .gattService:
                return "GattServer"
            case .gattClient:
                return "GattCLient"
            case .gattAdvertiser:
                return "Advertiser"
        }
    }
}
