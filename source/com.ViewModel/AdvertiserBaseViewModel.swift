//
//  AdvertiserBaseViewModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 19/06/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import CoreBluetooth

internal class AdvertiserBaseViewModel: NSObject {
    var advertiserID: String!
    var localName: String!
    var serviceUUID: [GattUUID] = []
    fileprivate(set) var restoreIdentifierKey: String = "#nRFConnect_Advertiser"

    
    init(localName: String, serviceUUID: [GattUUID]) {
        self.localName = localName
        self.serviceUUID = serviceUUID
        self.advertiserID = UUID().uuidString
    }
    
    init(advtiserID: String, localName: String, serviceUUID: [GattUUID]) {
        self.localName = localName
        self.serviceUUID = serviceUUID
        self.advertiserID = advtiserID
    }
    
    func getUUIDS() -> [CBUUID]
    {
        var uuids: [CBUUID] = []
        for item in self.serviceUUID {
            uuids.append(item.AssignedNumber)
        }
        return uuids
    }
}
