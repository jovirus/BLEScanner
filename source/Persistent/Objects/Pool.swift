//
//  EntityPool.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 10/04/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
internal class Pool {
    // The pool will live IN MEMORY as long as the session is alive. This id will be copied to sessionID field.
    var poolID: String
    var hasExpired: Bool
    
    init() {
        self.poolID = UUID().uuidString
        hasExpired = false
    }
}
