//
//  Log_BLESession.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 05/04/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
internal class Log_BLESession: Relation<EntityObject, EntityObject> {
    var sessionID: String
    var logID: Int
    
    init(record: Log, bleSession: BLESession) {
        self.sessionID = bleSession.sessionID
        self.logID = record.index
        super.init(subject: bleSession, relation: record)
    }
}
