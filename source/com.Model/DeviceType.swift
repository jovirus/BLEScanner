//
//  DeviceType.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 19/09/16.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
public enum DeviceTypeFilterEnum: UInt8 {
    case None = 0
    case nRFBeacon = 1
    case Eddystone = 2
    case PhysicalWeb = 3
    case SecureDFU = 4
    case LegacyDFU = 5
    case Thingy = 6
    
    static func getDeviceType(_ deviceType: String!) -> DeviceTypeFilterEnum {
        guard deviceType != nil, deviceType.trimmingCharacters(in:
            CharacterSet.whitespaces) != "" else {
            return .None
        }
        if deviceType == DeviceTypeFilterEnum.None.description() {
            return .None
        } else if deviceType == DeviceTypeFilterEnum.nRFBeacon.description() {
            return .nRFBeacon
        } else if deviceType == DeviceTypeFilterEnum.Eddystone.description() {
            return .Eddystone
        } else if deviceType == DeviceTypeFilterEnum.PhysicalWeb.description() {
            return .PhysicalWeb
        } else if deviceType == DeviceTypeFilterEnum.SecureDFU.description() {
            return .SecureDFU
        } else if deviceType == DeviceTypeFilterEnum.LegacyDFU.description() {
            return .LegacyDFU
        } else if deviceType == DeviceTypeFilterEnum.Thingy.description() {
            return .Thingy
        } else {
            return .None
        }
    }
    
    func description() -> String {
        switch self {
            case .None:
                return "None"
            case .nRFBeacon:
                return "nRF Beacon"
            case .Eddystone:
                return "Eddystone"
            case .PhysicalWeb:
                return "Physical Web"
            case .SecureDFU:
                return "Secure DFU"
            case .LegacyDFU:
                return "Legacy DFU"
            case .Thingy:
                return "Nordic Thingy"
        }
    }
}

