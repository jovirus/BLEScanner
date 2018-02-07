//
//  ActivityRecord.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 13/04/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation

internal class Log: EntityObject {
    var timeStamp: Date
    var activity: String
    var logType: LogType
    var stack: String
    // Foreigh keys
    var bleSession: BLESession
    
    init(message: String, logType: LogType, stack: String, bleSession: BLESession)
    {
        self.timeStamp = Date()
        self.activity = message
        self.logType = logType
        self.stack = stack
        self.bleSession = bleSession
        super.init()
    }
}

extension Log {
    
    func toString() -> String!
    {
        var tpString = ""
        tpString = self.timeStamp.logViewFormat + " " + activity
        let record =  tpString + "\n"
        return record
    }
}
