//
//  PersistentObjectManager.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 08/03/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation

open class PersistentObjectManager {
    
    static var instance = PersistentObjectManager()
    var companyIDListPersist = CompanyIDListPersist()
    init(){}
}
