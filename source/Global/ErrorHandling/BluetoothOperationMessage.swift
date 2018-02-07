//
//  BluetoothOperationMessage.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 22/03/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
public enum BluetoothOperationMessage: String {
    case connectPeriphral = "[MethodCall]connectPeripheral"
    case disconnectPeriphral = "[MethodCall]cancelPeripheralConnection"
    case discoverDevices = "[MethodCall]discoverDevices"
    case stopScan = "[MethodCall]stopScanning"
    case discoverServices = "[MethodCall]discoverServices"
    case discoverCharacteristics = "[MethodCall]discoverCharacteristicsForService"
    case discoverDescriptors = "[MethodCall]discoverDescriptorsForCharact."
    case readCharacteristicValue = "[MethodCall]readCharacteristicValue"
    case readDescriptorValue = "[MethodCall]readDescriptorValue"
    case writeCharacteristic = "[MethodCall]writeCharacteristic"
    case writeDescriptor = "[MethodCall]writeDescriptor"
    case setNotificationForCharact = "[MethodCall]setNotificationForCharact."

    case errorOccoursDiscoverServices = "[System]Error discover services"
    case successfulDiscoverServices = "[Callback]Successful discover service"
    case errorOccoursDiscoverCharacteristicsForService = "[System]Error discover charact. for service"
    case successfulDiscoverCharacteristicsForService = "[Callback]Successful discover charact. for service"
    case errorOccoursDiscoverDescriptorsForCharact = "[System]Error discover descriptors for charact."
    case successfulDiscoverDescriptorsForCharact = "[Callback]Successful discover descriptors for charact."
    case errorOccoursUpdateNotificationStateFor = "[System]Error update notification state for charact."
    case successfulUpdateNotificationStateFor = "[Callback]Successful update notification state for charact."
    case errorOccoursUpdateValueForCharact = "[System]Error update value for charact."
    case successfulUpdateValueForCharact = "[Callback]Successful update value for charact."
    case errorOccoursWriteValueForCharact = "[System]Error write value for charact."
    case successfulWriteValueForCharact = "[Callback]Successful write value for charact."
    case errorOccoursUpdateValueForDescriptor = "[System]Error update value for descriptor"
    case successfulUpdateValueForDescriptor = "[Callback]Successful update value for descriptor"
    case errorOccoursWriteValueForDescriptor = "[System]Error write value for descriptor"
    case successfulWriteValueForDescriptor = "[Callback]Successful write value for descriptor"
    
}
