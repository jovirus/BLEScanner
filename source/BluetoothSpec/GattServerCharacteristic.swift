//
//  GattCharacteristic.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 25/07/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import CoreBluetooth
class GattServerCharacteristic: GattUUID {
    var value: Data?
    var descriptors: [CBMutableDescriptor]?
    var properties: CBCharacteristicProperties
    var permissions: CBAttributePermissions
    var subscribedCentrals: [CBCentral]?

    
    init(assignedNumber: CBUUID, gattName: String, properties: CBCharacteristicProperties, permissions: CBAttributePermissions, value: Data? = nil, descriptors: [CBMutableDescriptor]? = nil) {
        self.value = value
        self.descriptors = descriptors
        self.properties = properties
        self.permissions = permissions
        super.init(assignedNumber: assignedNumber, gattName: gattName)
    }
}
