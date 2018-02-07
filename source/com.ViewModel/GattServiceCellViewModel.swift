//
//  GattServiceCellViewModel.swift
//  MasterControlPanel
//
//  Created by JiajunQiu on 08/11/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import CoreBluetooth
internal class GattServiceCellViewModel: CellViewModelBase {
    var PrimaryService: String = ""
    var cbService: CBService!
    
    static let UNKNOWN_SERVICE = "Unknown Service"
    let IS_PRIMARY_SERVICE = "PRIMARY SERVICE"
    let NON_PRIMARY_SERVICE = "NON-PRIMARY SERVICE"

    init (service: CBService)
    {
        super.init()
        self.setUUID(uuid: service.uuid)
        let name = GattServiceUUID.getServiceName(self.UUID)
        if  name == ""
        {
            self.Name = GattServiceCellViewModel.UNKNOWN_SERVICE
        }
        else
        {
            self.Name = name
        }
        if service.isPrimary
        {
            self.PrimaryService = IS_PRIMARY_SERVICE
        }
        else
        {
            self.PrimaryService = NON_PRIMARY_SERVICE
        }
        self.cbService = service
    }
    
    func getUUID() -> String! {
        guard self.UUID != nil else {
            return nil
        }
        return GattServiceUUID.getUUIDPrefix(uuid: self.UUID)
    }
    
    func isDFUService() -> Bool {
        if self.UUID == GattServiceUUID.SecureDeviceFirmwareUpdate.AssignedNumber || self.UUID == GattServiceUUID.LegacyDeviceFirmwareUpdate.AssignedNumber || self.UUID == GattServiceUUID.ExperimentalButtonlessDFUService.AssignedNumber {
            return true
        }
        return false
    }
}
