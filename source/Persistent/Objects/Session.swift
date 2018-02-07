//
//  nRFSession.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 31/03/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
/** A session is a connection with a period of time. A connection can be re-
established in a same session.
 */
internal class Session: EntityObject {
    //SessionID is same as registered poolID
    let sessionID: String
    let deviceID: String
    
    init(sessionID: String, deviceID: String, createdAt: Date) {
        self.sessionID = sessionID
        self.deviceID = deviceID
    }
}
