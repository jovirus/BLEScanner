//
//  Advertiser.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 22/08/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import EVReflection
import CoreBluetooth

class Advertiser: EVObject {
    var id: Int?
    var deviceName: String?
    var localName: String?
    var uuids: [String] = []

//    init(id: Int, deviceName: String, localName: String, services: [CBUUID]) {
//        self.id = id
//        self.deviceName = deviceName
//        self.localName = localName
//        self.uuids = services
//    }
//    
//    required init() {
//        super.ini
//    }
    
    override func propertyConverters() -> [(key: String, decodeConverter: ((Any?) -> ()), encodeConverter: (() -> Any?))] {
        return [
            ("id",
             { self.id = $0 as? Int },
             { return self.id }),
            ("deviceName",
             { self.deviceName = $0 as? String },
             { return self.deviceName }),
            ("localName",
             { self.localName = $0 as? String },
             { return self.localName }),
            ("uuids",
             { self.uuids = $0 as! [String] },
             { return self.uuids })
        ]
    }
}

class AdvertiserList: EVObject {
    var advertiserList: [Advertiser]?
}
