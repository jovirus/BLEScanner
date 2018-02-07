//
//  GattCharacteristicViewModel.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 27/10/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit
internal class GattCharacteristicCellViewModel: CellViewModelBase
{
    //var cellID: Int?
    var Properties: [String] = []
    var HasDescriptor: Bool!
    var cbCharacteristic: CBCharacteristic?
    static let UNKNOWN_CHARACTERISTIC = "Unknown Characteristic"

    func updateChacteristic(_ characteristic: CBCharacteristic, cellViewID: Int) ->GattCharacteristicCellViewModel {
        self.cbCharacteristic = characteristic
        self.setUUID(uuid: characteristic.uuid)
        if let tempValue = characteristic.value {
            let stringValue = DataConvertHelper.getNSData(tempValue)
            self.Value = stringValue
        }
        else {
            self.Value = Symbols.NOT_AVAILABLE
        }
        let name = GattCharacteristicsUUID.getChracteristicName(self.UUID)
        if name == "" {
            self.Name = GattCharacteristicCellViewModel.UNKNOWN_CHARACTERISTIC
        }
        else {
            self.Name = name
        }
        
        self.Properties = DataConvertHelper.getCharacteristicProperty(characteristic.properties)
        //getWriteType()
        
        if let descriptor = characteristic.descriptors {
            if descriptor.count == 0 {
                self.HasDescriptor = false
            }
            else {
                self.HasDescriptor = true
            }
        }
        else
        {
            self.HasDescriptor = false
        }
        super.cellIndex = cellViewID
        return self
    }
    
    func getUUID() -> String! {
        guard self.UUID != nil else {
            return nil
        }
        return GattCharacteristicsUUID.getUUIDPrefix(uuid: self.UUID)
    }
    
    func getPropertyDescription() -> String {
        var result: String = ""
        for item in self.Properties {
            let temp = item
            result += temp + " "
        }
        return result;
    }
}
