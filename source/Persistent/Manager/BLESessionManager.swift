//
//  BLESessionManager.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 11/04/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation

protocol SessionManagerProtocol {
    /** This method is called before a device is connected to phone. A pool will be created at the sametime.
     */
    static func createSession(forDevice deviceID: String, deviceName: String, peripheralConnectionStatus: BLEConnectStatus) -> BLESession
}

class BLESessionManager: SessionManagerProtocol {

    //static var instance = BLESessionManager()
    
    static func createSession(forDevice deviceID: String, deviceName: String, peripheralConnectionStatus: BLEConnectStatus) -> BLESession {
        let pool = PoolContainer.instance.createPool()
        let session = pool.createBLESession(deviceID: deviceID, deviceName: deviceName, connectionStatus: peripheralConnectionStatus,  phoneRole: .gattClient)
        return session
    }
    
    static func getSession(deviceID: String) -> BLESession! {
        if let pool = PoolContainer.instance.selectPool(deviceID: deviceID) {
            return pool.bleSession.first(where: { $0.deviceID == deviceID })!
        } else {
            return nil
        }
    }
    
    @discardableResult
    static func disposeSession(session: BLESession) -> Bool {
        var isSucceed = false
        guard PoolContainer.instance.isPoolExist(poolID: session.sessionID) else {
            return isSucceed
        }
        isSucceed = (PoolContainer.instance.selectPool(poolID: session.sessionID)?.closeBLESession(sessionID: session.sessionID))!
        return isSucceed
    }
}
