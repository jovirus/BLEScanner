//
//  GattDescriptorViewModel.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 29/10/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

internal class GattDescriptorViewModel: ViewModelBase
{
    static let DESCRIPTORS = "Descriptors"
    var listOfGattDescriptorViewCell: [GattDescriptorCellViewModel] = []
    
    fileprivate(set) var selectedDevice: BLEDevice!
    fileprivate(set) var session: BLESession!
    var selectedService: CBService?
    var selectedCharacteristic: CBCharacteristic?
    let minHeight = CGFloat(120)
    
    func findCell(_ descriptorUUID: CBUUID) -> GattDescriptorCellViewModel? {
        return findCell(descriptorUUID, gattViewCell: listOfGattDescriptorViewCell)
    }
    
    func setSelectedDevice(_ device: BLEDevice, session: BLESession) {
        self.selectedDevice = device
        self.session = session
    }
    
    func setSelectedDevice(_ device: BLEDevice) {
        self.selectedDevice = device
    }
}
