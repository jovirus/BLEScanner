//
//  BLESession.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 31/03/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
/** A BLEsession is used to describe a connection to a device with Generic Attributes(GATT). 
 A phone can act either a service or client.
 */
class BLESession: Session {
    var connectionStatus: BLEConnectStatus
    var phoneRole: GattRole
    
    init(sessionID: String, deviceID: String, createdAt: Date, connectionStatus: BLEConnectStatus, phoneRole: GattRole) {
        self.connectionStatus = connectionStatus
        self.phoneRole = phoneRole
        super.init(sessionID: sessionID, deviceID: deviceID, createdAt: createdAt)
    }
    
    convenience init(sessionID: String, deviceID: String, connectionStatus: BLEConnectStatus, phoneRole: GattRole) {
        self.init(sessionID: sessionID, deviceID: deviceID, createdAt: Date(), connectionStatus: connectionStatus, phoneRole: phoneRole)
    }
}
