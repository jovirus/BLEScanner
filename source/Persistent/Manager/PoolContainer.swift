//
//  Container.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 05/04/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
protocol PoolContainerProtocol {
    //Mark: - This shall only happen after a ble connection established.
    func createPool() -> EntityObjectPool
    func disposePool(poolID: String)
    func selectPool(poolID: String) -> EntityObjectPool?
    func disposeAllPool()
}


internal class PoolContainer: PoolContainerProtocol {

    fileprivate var _entityPoolDict: [String: EntityObjectPool] = [:]

    static var instance = PoolContainer()
    
    func createPool() -> EntityObjectPool {
        let newPool = EntityObjectPool()
        self._entityPoolDict[newPool.poolID] = newPool
        return newPool
    }
    
    func disposePool(poolID: String) {
        self._entityPoolDict[poolID] = nil
    }
    
    func selectPool(poolID: String) -> EntityObjectPool? {
        if self._entityPoolDict.keys.contains(poolID) {
            return self._entityPoolDict[poolID]
        } else {
            return nil
        }
    }
    
    func selectPool(deviceID: String) -> EntityObjectPool? {
        for (_, value) in self._entityPoolDict {
            for item in value.bleSession {
                if item.deviceID == deviceID {
                    return _entityPoolDict[item.sessionID]
                }
            }
        }
        return nil
    }
    
    func getAllPools() ->  [String: EntityObjectPool] {
        return _entityPoolDict
    }
    
    func disposeAllPool() {
        self._entityPoolDict.removeAll()
    }
    
    func isPoolExist(poolID: String) -> Bool {
        if _entityPoolDict.keys.contains(poolID) {
            return true
        } else
        {
            return false
        }
    }
}
