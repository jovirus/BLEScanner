//
//  nRFDeviceEntityProtocol.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 20/04/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
protocol nRFDeviceEntityProtocol : class {
    func addDevice(deviceID: String, deviceName: String)
}

extension EntityObjectPool: nRFDeviceEntityProtocol {
    
    //MARK: - nRFDevice Entity protocol
    func addDevice(deviceID: String, deviceName: String) {
        guard !nrfDevice.contains(where: { $0.deviceID == deviceID }) else {
            return
        }
        nrfDevice.append(nRFDevice(deviceID: deviceID, deviceName: deviceName))
    }
}
