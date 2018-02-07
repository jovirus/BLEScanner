//
//  LogEntityProtocol.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 05/04/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation

protocol LogEntityProtocol: class {
    func setRecord(with newRecord: Log, session: BLESession)
    func removeAll()
}

extension EntityObjectPool: LogEntityProtocol {
    //MARK:  LogEntity Protocol
    func setRecord(with newRecord: Log, session: BLESession)
    {
        records.append(newRecord)
        newRecord.index = records.count - 1
        let session = Log_BLESession(record: newRecord, bleSession: session)
        log_BLESession.append(session)
     }
    
    func removeAll()
    {
        self.records.removeAll()
    }
    
    func recordsDescription() -> String
    {
        var result = ""
        for index in 0..<self.records.count {
            guard let value = self.records[index] else {
                continue
            }
           result += value.toString()
        }
        return result
    }
}
