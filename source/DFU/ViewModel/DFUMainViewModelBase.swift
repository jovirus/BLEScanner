//
//  DFUMainViewModelBase.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 18/01/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import CoreBluetooth

class DFUMainViewModelBase {
    var centralMananger: CBCentralManager
    var peripheral: CBPeripheral
    fileprivate(set) var selectedDevice: BLEDevice
    fileprivate(set) var session: BLESession
    
    required init(centralMananger: CBCentralManager, peripheral: CBPeripheral, device: BLEDevice, session: BLESession) {
        self.centralMananger = centralMananger
        self.peripheral = peripheral
        self.selectedDevice = device
        self.session = session
    }
    
    func guardPeripheralConnected() {
        guard self.peripheral.state != .connected else { return }
        BLEDeviceManager.instance().connectPeriphral(self.centralMananger, peripheral: self.peripheral)
    }
}
