//
//  AdvertiserSessionManager.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 21/08/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
class AdvertiserSessionManager: SessionManagerProtocol {
    /** This method is called before a device is connected to phone. A pool will be created at the sametime.
     */
    static func createSession(forDevice deviceID: String, deviceName: String, peripheralConnectionStatus: BLEConnectStatus) -> BLESession {
        let pool = PoolContainer.instance.createPool()
        let session = pool.createBLESession(deviceID: deviceID, deviceName: deviceName, connectionStatus: peripheralConnectionStatus,  phoneRole: .gattAdvertiser)
        return session
    }
}
