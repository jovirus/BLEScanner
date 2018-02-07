//
//  LogManager.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 14/04/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
protocol LogActivityNotificationDelegate {
    func didActivityAdd(activity: Log, session: Session)
    func didActivitiesAllDelete(session: Session)
}

/**Log manager provides all necessary methods for application layer to access log objects.
  */
open class LogManager: LogManagerProtocol {

    var newActivityNotificationDelegate: LogActivityNotificationDelegate?
    
    static var instance = LogManager()
    
    @discardableResult
    func addLog(_ message: String, logType: LogType, object: String, session: BLESession) -> Bool
    {
        guard let pool = PoolContainer.instance.selectPool(poolID: session.sessionID) else {
            return false
        }
        
        let activity = Log(message: message, logType: logType, stack: object, bleSession: session)
        pool.setRecord(with: activity, session: session)
        newActivityNotificationDelegate?.didActivityAdd(activity: activity, session: session)
        return true
    }
    
    func getLogByType(_ type: LogType, session: BLESession) -> [Log]? {
        guard let pool = PoolContainer.instance.selectPool(poolID: session.sessionID) else {
            return nil
        }
        
        var tagedRecords: [Log] = []
        let tagLevel = type.rawValue
        tagedRecords = pool.records.filter({
            let storedLevel = $0.logType.rawValue
            if storedLevel >= tagLevel
            {
                return true
            }
            return false
        })
        return tagedRecords
    }
    
    func getLog(session: BLESession) -> [Log]?
    {
        guard let pool = PoolContainer.instance.selectPool(poolID: session.sessionID) else {
            return nil
        }
        
        var tagedRecords: [Log] = []
        tagedRecords.append(contentsOf: pool.records.filter { (x) -> Bool in
            return x.hasExpired == false
        })
        return tagedRecords
    }
    
    func getLog(id: Int, session: BLESession) -> Log! {
        guard let logs = getLog(session: session), id < logs.count, id >= 0 else {
            return nil
        }
        return logs[id]
    }
    
    func getAllRecords(session: BLESession) -> String?
    {
        guard let pool = PoolContainer.instance.selectPool(poolID: session.sessionID) else {
            return nil
        }
        
       return pool.recordsDescription()
    }
    
    func saveLog(content: String, session: BLESession) -> Bool {
        
        var haveSaved = false
        if LocalAccessManager.instance.isLogExist(fileName: session.sessionID) {
            LocalAccessManager.instance.appendNewLog(newRecords: content, logID: session.sessionID, completion: { (url, error) in
                if error == nil {
                    haveSaved = true
                }
            }, session: session)
        } else {
            LocalAccessManager.instance.createLog(content, logID: session.sessionID, completion: { (url, error) in
                if error == nil {
                    haveSaved = true
                }
            }, session: session)
        }
        return haveSaved
    }
    
    @discardableResult
    func removeLog(session: BLESession) -> Bool
    {
        guard let pool = PoolContainer.instance.selectPool(poolID: session.sessionID) else {
            return false
        }
        
        pool.removeAll()
        newActivityNotificationDelegate?.didActivitiesAllDelete(session: session)
        return true
    }
}
