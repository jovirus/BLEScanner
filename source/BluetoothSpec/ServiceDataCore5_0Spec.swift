//
//  ServiceDataCore5_0Spec.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 12/10/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import CoreBluetooth

//MARK: - SERVICE DATA lead by 16/32/128 bits UUID followed by additional service data
//        see more in bluetooth core supplement PartA 1.11
struct ServiceDataCore5_0Spec {
    var uuid: CBUUID
    var data: Data?
    
    init(uuid: CBUUID, data: Data?) {
        self.uuid = uuid
        self.data = data
    }
}
