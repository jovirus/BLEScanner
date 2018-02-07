//
//  DFUFileType.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 13/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
enum DFUFileKind: String {
    case DistributionPackage = "Distribution packet (Zip)"
    case Binary = "Binary"
    case Dat = "Dat"
    case NonSupported = "Non-supported"
    
    static func getValue(type: String) -> DFUFileKind! {
        var value: DFUFileKind!
            switch type {
            case "Distribution packet (Zip)":
                value = self.DistributionPackage
            case "Binary":
                value = self.Binary
            case "Dat":
                value = self.Dat
            case "Non-supported":
                value = self.NonSupported
            default:
                value = nil
            }
        return value
    }
}
