//
//  CompanyIDPersist.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 04/03/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
import EVReflection

open class CompanyIDListPersist: EVObject {
    var Created = ""
    var ResourceFrom = ""
    var companies: [CompanyIDPersist]? = []
}

open class CompanyIDPersist: EVObject {
    var DecimalValue: String = ""
    var HexaValue: String = ""
    var CompanyName: String = ""
}
