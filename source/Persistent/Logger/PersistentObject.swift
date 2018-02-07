//
//  PersistentObject.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 13/04/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation

internal class EntityObject {
    var createdAt: Date
    //Only used for immutable entity objects for example log
    var index: Int = 0
    var hasExpired: Bool
    
    init() {
        createdAt = Date()
        hasExpired = false
    }
}
