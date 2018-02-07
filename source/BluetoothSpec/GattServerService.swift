//
//  GattServerService.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 26/07/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import CoreBluetooth

class GattServerService: GattUUID {
    var characteristics: [CBCharacteristic]?
    var isPrimary: Bool
    
    init(assignedNumber: CBUUID, gattName: String, isPrimary: Bool, characteristics: [CBCharacteristic]?) {
        self.isPrimary = isPrimary
        self.characteristics = characteristics
        super.init(assignedNumber: assignedNumber, gattName: gattName)
    }
}
