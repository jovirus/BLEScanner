//
//  GattDescriptorCellViewModel.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 29/10/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import CoreBluetooth

internal class GattDescriptorCellViewModel: CellViewModelBase {

    let UNKNOWN_DESCRIPTOR = "Unknown descriptor"
    var cbDescriptor: CBDescriptor?
    
    func updateDescriptor(_ descriptor: CBDescriptor) -> GattDescriptorCellViewModel {
        self.cbDescriptor = descriptor
        let value = DataConvertHelper.getDescriptorValue(descriptor.value as AnyObject?)
        if value == "" {
            self.Value = Symbols.NOT_AVAILABLE
        }
        else {
            self.Value = value
        }
        self.setUUID(uuid: descriptor.uuid)
        let result = GattDescriptorUUID.getDescriptorName(self.UUID)
        if result != "" {
            self.Name = result
        }
        else {
            self.Name = UNKNOWN_DESCRIPTOR
        }
        return self
    }
    
    func getUUID() -> String! {
        guard self.UUID != nil else {
            return nil
        }
        return GattDescriptorUUID.getUUIDPrefix(uuid: self.UUID)
    }
}
