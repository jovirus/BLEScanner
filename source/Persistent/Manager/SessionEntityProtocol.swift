//
//  BLESessionEntityProtocol.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 06/04/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
protocol SessionEntityProtocol: class {
    func createBLESession(deviceID: String, deviceName: String, connectionStatus: BLEConnectStatus, phoneRole: GattRole) -> BLESession
    func closeBLESession(index: Int) throws
    func connectStatusChange(on deviceID: String, status: BLEConnectStatus) throws
    func getSessionID(deviceID: String) throws -> String
    func closeAllSession()
}

extension EntityObjectPool: SessionEntityProtocol {
     //MARK: - BLESession Protocol
    func createBLESession(deviceID: String, deviceName: String, connectionStatus: BLEConnectStatus, phoneRole: GattRole) -> BLESession {
        addDevice(deviceID: deviceID, deviceName: deviceName)
        let session = BLESession(sessionID: self.poolID, deviceID: deviceID, connectionStatus: connectionStatus, phoneRole: phoneRole)
        bleSession.append(session)
        return session
    }
    
    func closeBLESession(index: Int) throws {
        guard index >= 0 || index < bleSession.count else {
            throw EntityObjectAccessError.invalidCriteria
        }
        bleSession[index].hasExpired = true
    }
    
    func closeBLESession(sessionID: String) -> Bool {
        var isSucceed = false
        if let index = self.bleSession.index(where: { $0.sessionID == sessionID }) {
            bleSession[index].hasExpired = true
            isSucceed = true
        }
        return isSucceed
    }
    
    func closeAllSession() {
        bleSession.removeAll()
    }
    
    func connectStatusChange(on deviceID: String, status: BLEConnectStatus) throws {
        if let index = bleSession.index(where: { $0.deviceID == deviceID }) {
            bleSession[index].connectionStatus = status
        } else {
            throw EntityObjectAccessError.noDataFound
        }
    }
    
    func getSessionID(deviceID: String) throws -> String {
        if let index = bleSession.index(where: { $0.deviceID == deviceID }) {
           return bleSession[index].sessionID
        } else {
            throw EntityObjectAccessError.noDataFound
        }
    }
    
    func isSessionExist(sessionID: String) -> Bool {
        return bleSession.contains(where: {$0.sessionID == sessionID} )
    }
}






