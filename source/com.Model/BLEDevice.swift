//
//  BLEDevice.swift
//  FIrstAppleProject
//
//  Created by Jiajun Qiu on 25/06/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import CoreBluetooth

internal class BLEDevice {
    
    var deviceName: String = Symbols.NOT_AVAILABLE
    var deviceID: String = Symbols.NOT_AVAILABLE
    var connectionStatus: BLEConnectStatus
    var rssi: String {
        get{
            guard let value = rssiValue else {
                return Symbols.NOT_AVAILABLE
            }
            return String(value)
        }
    }
    private(set) var rssiValue: Int!
    var advertisementPackage = AdvertisementPackageWrapper()
    var cBPeripheral: CBPeripheral!
    var createdAt: Date
    
    init() {
        self.createdAt = Date()
        self.connectionStatus = .connected
    }

    
    init(deviceName: String!, deviceID: String, connectionStatus: CBPeripheralState, deviceSignalStrengthen: Int, advertisementPackage: AdvertisementPackageWrapper, peripheral: CBPeripheral)
    {
        self.deviceName = deviceName == nil ?  Symbols.NOT_AVAILABLE : deviceName
        self.deviceID = deviceID
        self.connectionStatus = BLEConnectStatus.setStatus(status: connectionStatus)
        self.rssiValue = deviceSignalStrengthen
        self.advertisementPackage = advertisementPackage;
        self.cBPeripheral = peripheral
        self.createdAt = Date()
    }
    
    init(deviceName: String!, deviceID: String, connectionStatus: CBPeripheralState, peripheral: CBPeripheral)
    {
        self.deviceName = deviceName == nil ?  Symbols.NOT_AVAILABLE : deviceName
        self.deviceID = deviceID
        self.connectionStatus = BLEConnectStatus.setStatus(status: connectionStatus)
        self.cBPeripheral = peripheral
        self.createdAt = Date()
    }
    
    init(device: CBPeripheral)
    {
        if let name = device.name
        {
            self.deviceName = name
        }
        self.deviceID = device.identifier.uuidString
        self.connectionStatus = BLEConnectStatus.setStatus(status: device.state)
        self.cBPeripheral = device
        self.createdAt = Date()
    }
    
    func update(newBLEDevice: BLEDevice) {
        guard newBLEDevice.deviceID == self.deviceID else { return }
        self.deviceName = newBLEDevice.deviceName
        self.deviceID = newBLEDevice.deviceID
        self.connectionStatus = newBLEDevice.connectionStatus
        self.rssiValue = newBLEDevice.rssiValue
        self.advertisementPackage = newBLEDevice.advertisementPackage
        self.cBPeripheral = newBLEDevice.cBPeripheral
        self.createdAt = newBLEDevice.createdAt
    }
}
