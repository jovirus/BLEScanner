//
//  DataAccessManager.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 10/04/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation

protocol  DataAccessManagerProtocol {
//    func initialDataAccessForBLEConnection (forDevice deviceID: String, peripheralConnectionStatus: BLEConnectStatus) -> String
    //func isValidSession(sessionID: String) -> Bool
}

class DataAccessManager {
    
    typealias createSession = (_ deviceID: String, _ peripheralConnectionStatus: BLEConnectStatus) -> String
    
//    func initialDataAccessForBLEConnection(forDevice deviceID: String, peripheralConnectionStatus: BLEConnectStatus) -> String {
//        let pool = BLEPoolContainer.instance.createPool()
//        let sessionID = pool.createBLESession(deviceID: deviceID, connectionStatus: peripheralConnectionStatus,  phoneRole: .gattClient)
//        return sessionID
//    }
//    
//    func isValidSession(sessionID: String) -> Bool {
//        return BLEPoolContainer.instance.isPoolExist(poolID: sessionID) && (BLEPoolContainer.instance.selectPool(poolID: sessionID)?.isSessionExist(sessionID: sessionID))!
//    }
    
}
