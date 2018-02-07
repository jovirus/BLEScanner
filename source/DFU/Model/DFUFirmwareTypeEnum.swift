//
//  DFUFirmwareTypeEnum.swift
//  nRFConnect
//
//  Created by Jiajun Qiu on 21/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import iOSDFULibrary

enum DFUFirmwareTypeEnum : String {
    case softdevice = "Softdevice"
    case bootloader = "Bootloader"
    case application = "Application"
    case softdeviceBootloader = "Softdevice and Bootloader"
    // Not in use
//    case softdeviceBootloaderApplication = "Softdevice, Bootloader and Application"
    
    static let allType: [String] = ["Softdevice", "Bootloader", "Application", "Softdevice and Bootloader"]
    
    static func convertValue(description: String) -> DFUFirmwareType! {
        var value: DFUFirmwareType!
        if let result = self.allType.index(of: description) {
            switch result {
            case 0:
                value = DFUFirmwareType.softdevice
            case 1:
                value = DFUFirmwareType.bootloader
            case 2:
                value = DFUFirmwareType.application
            case 3:
                value = DFUFirmwareType.softdeviceBootloader
            default:
                value = nil
            }
        }
        return value
    }
    
    static func getValue(type: DFUFirmwareType) -> DFUFirmwareTypeEnum {
        var value: DFUFirmwareTypeEnum!
            switch type {
            case .application:
                value = .application
            case .bootloader:
                value = .bootloader
            case .softdevice:
                value = .softdevice
            case .softdeviceBootloader:
                value = .softdeviceBootloader
            default:
                break
            }
            return value
        }
    
    static func convertValue(dfuFirmwareTypeEnum: String) -> DFUFirmwareTypeEnum! {
        var value: DFUFirmwareTypeEnum!
        if let result = self.allType.index(of: dfuFirmwareTypeEnum) {
            switch result {
            case 0:
                value = DFUFirmwareTypeEnum.softdevice
            case 1:
                value = DFUFirmwareTypeEnum.bootloader
            case 2:
                value = DFUFirmwareTypeEnum.application
            case 3:
                value = DFUFirmwareTypeEnum.softdeviceBootloader
            default:
                value = nil
            }
        }
        return value
    }

}
