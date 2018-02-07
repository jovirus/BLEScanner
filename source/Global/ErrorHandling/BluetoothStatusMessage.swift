//
//  BluetoothStatusMessage.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 22/03/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation

public enum BluetoothStatusMessage : String {
    
    case unknown = "[System]CoreBluetooth BLE hardware is unknown"
    case resetting = "[System]CoreBluetooth BLE hardware is resetting"
    case unsupported = "[System]CoreBluetooth BLE hardware is unsupported on this platform"
    case unauthorized = "[System]CoreBluetooth BLE hardware is unauthorized"
    case poweredOff = "[System]CoreBluetooth BLE hardware is powered off"
    case poweredOn = "[System]CoreBluetooth BLE hardware is powered on and ready"
    
    case errorOccursDisconnectPeripheral = "[System]Error disconnect from peripheral"
    case successfulDisconnectPeripheral = "[Callback]Successful disconnect from peripheral"
    case failedConnectPeripheralWithError = "[System]Failed connect to peripheral with error"
    case failedConnectPeripheral = "[System]Failed connect to peripheral"
    case successfulConnectPeripheral = "[Callback]Successful connect to peripheral"
    
}
