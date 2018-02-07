//
//  GattCharacteristicPageViewModel.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 28/10/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

internal class  GattCharacteristicViewModel: ViewModelBase {
    var listOfGattCharacteristicViewCell: [GattCharacteristicCellViewModel] = []
    fileprivate(set) var selectedDevice: BLEDevice?
    fileprivate(set) var session: BLESession!
    var selectedService: CBService?
    
    let UNKNOW_SERVICE = "Unknow Characteristic"
    let CHARACTERISTICS = "Characteristics"
    
    let minHeight = CGFloat(140)

    func findCell(_ characteristicUUID: CBUUID) -> GattCharacteristicCellViewModel? {
        var targetCellViewModel: GattCharacteristicCellViewModel?
        let result = self.listOfGattCharacteristicViewCell.filter{ (x) in x.UUID == characteristicUUID }
        guard let cell = result.first else { return nil }
        targetCellViewModel = cell
        return targetCellViewModel
    }
    
    func getDescriptionWriteType(_ value: CBCharacteristicWriteType) -> String {
        let strings = ["WithResponse", "WithoutResponse"]
        return strings[value.rawValue]
    }
    
    func setSelectedDevice(_ device: BLEDevice, session: BLESession) {
        self.selectedDevice = device
        self.session = session
    }
    
    func setSelectedDevice(_ device: BLEDevice) {
        self.selectedDevice = device
    }
}
