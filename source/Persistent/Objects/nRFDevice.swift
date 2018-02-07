//
//  nRFDevice.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 04/04/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
class nRFDevice: EntityObject {
    var deviceName: String
    var deviceID: String
    
    init(deviceID: String, deviceName: String) {
        self.deviceID = deviceID
        self.deviceName = deviceName
    }
}
