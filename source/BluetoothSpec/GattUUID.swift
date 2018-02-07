//
//  GattUUID.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 18/09/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import CoreBluetooth
class GattUUID: Equatable {
    var AssignedNumber: CBUUID
    var GattName: String = ""
    
    init (assignedNumber: CBUUID, gattName: String) {
        AssignedNumber = assignedNumber
        GattName = gattName
    }
    
    init(assignedNumber: Data, gattName: String) {
        AssignedNumber = CBUUID(data: assignedNumber)
        GattName = gattName
    }
    
    func description() -> String {
        return self.GattName + Symbols.bracketLeft + self.AssignedNumber.uuidString + Symbols.bracketRight
    }
    
    public static func ==(lhs: GattUUID, rhs: GattUUID) -> Bool {
        guard lhs.AssignedNumber == rhs.AssignedNumber else { return false }
        return true
    }
}
