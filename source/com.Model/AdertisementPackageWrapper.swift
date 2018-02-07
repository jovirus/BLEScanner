//
//  AdertisementPackageWrapper.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 03/08/15.
//  Copyright (c) 2015 Jiajun Qiu. All rights reserved.
//

import CoreBluetooth
import Foundation

class AdvertisementPackageWrapper {
    
    var cBAdvertisementDataLocalName = Symbols.NOT_AVAILABLE
    var cBAdvertisementDataManufacturerData: Data?
    var cBAdvertisementDataServiceData: NSDictionary = NSDictionary()
    var cBAdvertisementDataServiceUUIDs: [GattUUID] = []
    var cBAdvertisementDataOverflowServiceUUIDs: [GattUUID] = []
    var cBAdvertisementDataTxPowerLevel = Symbols.NOT_AVAILABLE
    var cBAdvertisementDataIsConnectable: Bool!
    var cBAdvertisementDataSolicitedServiceUUIDs: [GattUUID] = []
    
    init() {}
}
