
//
//  BLEDeviceManager.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 26/06/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//
import CoreBluetooth
import Foundation

protocol BLEDeviceManagerAdvertisementDelegate{    
    func didReceiveAdvertisementPackage(_ newDevice: BLEDevice)
}

protocol BLEDeviceManagerScanningActionDelegate{
    func didScanningActionChanged(_ isScanningOn: Bool)
}

protocol BLEDeviceManagerDeviceConnectionDelegate
{
    func hasDeviceConnectionStatusChanged(isConnected: Bool, updatedDevice: BLEDevice, error: NSError?)
}

protocol BLEDeviceManagerGattServiceDiscoveriedDelegate
{
    func didDiscoveryService(_ device: BLEDevice)
}

protocol BLEDeviceManagerGattCharacteristicDelegate
{
    func didDiscoveryCharacteristic()
}

protocol BLEDeviceManagerDescriptorDelegate
{
    func didUpdateValueDescriptor(_ descriptor: CBDescriptor, error: NSError?)
    func didWriteValueForDescriptor(_ Descriptor: CBDescriptor, error: NSError?)
}

protocol BLEDeviceManagerCharacteristicDelegate
{
    func didUpdateValueForCharacteristic(_ characteristic: CBCharacteristic, error: NSError?)
    func didWriteValueForCharacteristic(_ characteristic: CBCharacteristic, error: NSError?)
}

protocol BLEDeviceManagerBleHardwareStatusChangedDelegate
{
    func hasBleHardwareStatusChanged(_ isAvailable: Bool)
}

open class BLEDeviceManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate
{
    var centralManager:CBCentralManager!
    fileprivate var deviceManagerAdvertisementDelegate: Dictionary<String, BLEDeviceManagerAdvertisementDelegate> = [:]
    var deviceManagerScanningActionDelegate: BLEDeviceManagerScanningActionDelegate?
    var deviceManagerGattServiceDiscoveriedDelegate: BLEDeviceManagerGattServiceDiscoveriedDelegate?
    var deviceManagerGattCharacteristicDelegate: BLEDeviceManagerGattCharacteristicDelegate?
    var deviceManagerDeviceConnectionDelegate: BLEDeviceManagerDeviceConnectionDelegate?
    var deviceManagerDescriptorDelegate: BLEDeviceManagerDescriptorDelegate?
    var deviceManagerCharacteristicDelegate: BLEDeviceManagerCharacteristicDelegate?
    var deviceManagerBleHardwareStatusChangedDelegate: BLEDeviceManagerBleHardwareStatusChangedDelegate?

    fileprivate static var instanceObj:BLEDeviceManager!
    open static func instance() -> BLEDeviceManager
    {
        if instanceObj == nil
        {
            instanceObj = BLEDeviceManager()
            return instanceObj!
        }
        instanceObj!.centralManager.delegate = instanceObj
        return instanceObj!
    }
    
    fileprivate var logManager: LogManager
    
    fileprivate override init()
    {
        self.logManager = LogManager.instance
        super.init()
//        let centralQueue = DispatchQueue(label: "com.nordicsemi.nRFConnect.deviceManager", attributes: [])
        centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager.delegate = self
    }
    
    //MARK: - Register delegate
    func registerDelegate(_ className: String, receiver: BLEDeviceManagerAdvertisementDelegate) {
        self.deviceManagerAdvertisementDelegate[className] = receiver
    }
    
    func removeRegisteredDelegates(_ className: String) {
        
       if self.deviceManagerAdvertisementDelegate[className] != nil
       {
            self.deviceManagerAdvertisementDelegate[className] = nil
       }
    }
    
    func removeAllRegisteredDelegates() {
        self.deviceManagerAdvertisementDelegate.removeAll()
    }
    
    open func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        var isAvailable: Bool = false
        switch (central.state) {
        case .poweredOff:
            print(BluetoothStatusMessage.poweredOff.description)
//            logManager.addLog(BluetoothStatusMessage.poweredOff.description, logType: .debug, object: #function)
        case .poweredOn:
            print(BluetoothStatusMessage.poweredOn.description)
//            logManager.addLog(BluetoothStatusMessage.poweredOn.description, logType: .debug, object: #function)
            discoverDevices()
            isAvailable = true
        case .resetting:
            print(BluetoothStatusMessage.resetting.description)
//            logManager.addLog(BluetoothStatusMessage.resetting.description, logType: .debug, object: #function)
        case .unauthorized:
            print(BluetoothStatusMessage.unauthorized.description)
//            logManager.addLog(BluetoothStatusMessage.unauthorized.description, logType: .debug, object: #function)
        case .unknown:
            print(BluetoothStatusMessage.unknown.description)
//            logManager.addLog(BluetoothStatusMessage.unknown.description, logType: .debug, object: #function)
        case .unsupported:
            print(BluetoothStatusMessage.unsupported.description)
//            logManager.addLog(BluetoothStatusMessage.unsupported.description, logType: .debug, object: #function)
        }
        deviceManagerBleHardwareStatusChangedDelegate?.hasBleHardwareStatusChanged(isAvailable)
        deviceManagerScanningActionDelegate?.didScanningActionChanged(isAvailable)
   }
    
    //MARK: - Device management
    func connectPeriphral(_ centralManager: CBCentralManager, peripheral: CBPeripheral)
    {
        logManager.addLog(BluetoothOperationMessage.connectPeriphral.description, logType: .verbose, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
//        centralManager.delegate = self
        centralManager.connect(peripheral, options: nil)
    }
    
    func disconnectPeriphral(_ centralManager: CBCentralManager, peripheral: CBPeripheral)
    {
        logManager.addLog(BluetoothOperationMessage.disconnectPeriphral.description, logType: .verbose, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
        centralManager.cancelPeripheralConnection(peripheral)
    }
    
    func discoverDevices()
    {
        //logManager.addLog(BluetoothOperationMessage.discoverDevices.description, logType: .verbose, object: #function)
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
        deviceManagerScanningActionDelegate?.didScanningActionChanged(true)
    }
    
    func stopScan()
    {
        //logManager.addLog(BluetoothOperationMessage.stopScan.description, logType: .verbose, object: #function)
        centralManager.stopScan()
        deviceManagerScanningActionDelegate?.didScanningActionChanged(false)
    }
    
    open func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        let bleDevice = BLEDevice(deviceName: peripheral.name, deviceID: "\(peripheral.identifier.uuidString)",
                                  connectionStatus: peripheral.state, peripheral: peripheral)
        if error != nil
        {
            logManager.addLog(BluetoothStatusMessage.errorOccursDisconnectPeripheral.description + Symbols.whiteSpace + bleDevice.deviceName + Symbols.whiteSpace + (error?.localizedDescription)!, logType: .error, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
        } else {
            logManager.addLog(BluetoothStatusMessage.successfulDisconnectPeripheral.description + Symbols.whiteSpace + bleDevice.deviceName, logType: .debug, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
        }
        self.deviceManagerDeviceConnectionDelegate?.hasDeviceConnectionStatusChanged(isConnected: false, updatedDevice: bleDevice, error: error as NSError?)
    }
    
    open func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        let bleDevice = BLEDevice(deviceName: peripheral.name, deviceID: "\(peripheral.identifier.uuidString)",
                                  connectionStatus: peripheral.state, peripheral: peripheral)
        if error != nil
        {
            logManager.addLog(BluetoothStatusMessage.failedConnectPeripheralWithError.description + Symbols.whiteSpace + (error?.localizedDescription)!, logType: .error, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
        } else {
            logManager.addLog(BluetoothStatusMessage.failedConnectPeripheral.description + Symbols.whiteSpace + bleDevice.deviceName, logType: .debug, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
        }
        self.deviceManagerDeviceConnectionDelegate?.hasDeviceConnectionStatusChanged(isConnected: false, updatedDevice: bleDevice, error: error as NSError?)
    }
    
    open func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let advPackage = BLEAdvertisementPackageHandler.readAdvertisementPackage(advertisementData)
        let bleDevice = BLEDevice(deviceName: peripheral.name, deviceID: peripheral.identifier.uuidString,
                                  connectionStatus: peripheral.state, deviceSignalStrengthen: RSSI.intValue, advertisementPackage: advPackage, peripheral: peripheral)
        for (_, receiver) in self.deviceManagerAdvertisementDelegate
        {
            receiver.didReceiveAdvertisementPackage(bleDevice)
        }
    }

    open func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        let bleDevice = BLEDevice(deviceName: peripheral.name, deviceID: peripheral.identifier.uuidString,
            connectionStatus: peripheral.state, peripheral: peripheral)
        logManager.addLog(BluetoothStatusMessage.successfulConnectPeripheral.description + Symbols.whiteSpace + bleDevice.deviceName, logType: .debug, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
        deviceManagerDeviceConnectionDelegate?.hasDeviceConnectionStatusChanged(isConnected: true, updatedDevice: bleDevice, error: nil)
    }
    
    // MARK: - services
    open func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)
    {
        if let eRROR = error
        {
            logManager.addLog(BluetoothOperationMessage.errorOccoursDiscoverServices.description + Symbols.whiteSpace + eRROR.localizedDescription, logType: .error, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
        }
        else if let services = peripheral.services
        {
            let device = BLEDevice(device: peripheral)
            for service in services
            {
                logManager.addLog(BluetoothOperationMessage.successfulDiscoverServices.description + Symbols.whiteSpace + service.uuid.uuidString, logType: .debug, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
                peripheral.discoverCharacteristics(nil, for: service)
            }
            deviceManagerGattServiceDiscoveriedDelegate?.didDiscoveryService(device)
        }
    }
    
    // MARK: - charact.
    open func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let eRROR = error
        {
            logManager.addLog(BluetoothOperationMessage.errorOccoursDiscoverCharacteristicsForService.description + Symbols.whiteSpace + service.uuid.uuidString + Symbols.whiteSpace + eRROR.localizedDescription, logType: .error, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
        }
        else if let charactericsArr = service.characteristics
        {
            for charactericsx in charactericsArr
            {
                logManager.addLog(BluetoothOperationMessage.successfulDiscoverCharacteristicsForService.description + Symbols.whiteSpace + service.uuid.uuidString, logType: .debug, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
                readCharacteristicValue(peripheral, characteristic: charactericsx)
                discoverDescriptorsForCharact(peripheral: peripheral, characteristic: charactericsx)
            }
        }
    }
    
    open func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let eRROR = error
        {
            logManager.addLog(BluetoothOperationMessage.errorOccoursUpdateNotificationStateFor.description + Symbols.whiteSpace + characteristic.uuid.uuidString + eRROR.localizedDescription, logType: .error, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
        }
        else if let listOfDescriptors = characteristic.descriptors
        {
            logManager.addLog(BluetoothOperationMessage.successfulUpdateNotificationStateFor.description + Symbols.whiteSpace + characteristic.uuid.uuidString, logType: .debug, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
            for descriptor in listOfDescriptors
            {
                readDescriptorValue(peripheral, descriptor: descriptor)
            }
        }
    }

    func writeCharacteristic(_ peripheral: CBPeripheral, data: Data, characteristic: CBCharacteristic, type: CBCharacteristicWriteType)
    {
        logManager.addLog(BluetoothOperationMessage.writeCharacteristic.description + Symbols.whiteSpace + characteristic.uuid.uuidString, logType: .verbose, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
        peripheral.writeValue(data, for: characteristic, type: type)
    }
    
    func readCharacteristicValue(_ peripheral: CBPeripheral, characteristic: CBCharacteristic)
    {
        logManager.addLog(BluetoothOperationMessage.readCharacteristicValue.description + Symbols.whiteSpace + characteristic.uuid.uuidString, logType: .verbose, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
        peripheral.readValue(for: characteristic)
    }
    
    open func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let err = error
        {
            logManager.addLog(BluetoothOperationMessage.errorOccoursUpdateValueForCharact.description + Symbols.whiteSpace + characteristic.uuid.uuidString + Symbols.whiteSpace + err.localizedDescription, logType: .error, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
            deviceManagerCharacteristicDelegate?.didUpdateValueForCharacteristic(characteristic, error: err as Error? as NSError?)
        }
        else if let _ = characteristic.value
        {
            logManager.addLog(BluetoothOperationMessage.successfulUpdateValueForCharact.description + Symbols.whiteSpace + characteristic.uuid.uuidString, logType: .debug, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
            deviceManagerCharacteristicDelegate?.didUpdateValueForCharacteristic(characteristic, error: nil)
        }
    }
    
    open func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let err = error
        {
            logManager.addLog(BluetoothOperationMessage.errorOccoursWriteValueForCharact.description + Symbols.whiteSpace + characteristic.uuid.uuidString + Symbols.whiteSpace + err.localizedDescription, logType: .error, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
            deviceManagerCharacteristicDelegate?.didWriteValueForCharacteristic(characteristic, error: err as NSError?)
        }
        else if let _ = characteristic.value
        {
            logManager.addLog(BluetoothOperationMessage.successfulWriteValueForCharact.description + Symbols.whiteSpace + characteristic.uuid.uuidString, logType: .debug, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
            deviceManagerCharacteristicDelegate?.didWriteValueForCharacteristic(characteristic, error: nil)
        }
    }
    
    //MARK: - Descriptor
    func discoverDescriptorsForCharact(peripheral: CBPeripheral, characteristic: CBCharacteristic) {
        logManager.addLog(BluetoothOperationMessage.discoverDescriptors.description + Symbols.whiteSpace + characteristic.uuid.uuidString, logType: .verbose, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
        peripheral.discoverDescriptors(for: characteristic)
    }
    
    func readDescriptorValue(_ peripheral: CBPeripheral, descriptor: CBDescriptor)
    {
        logManager.addLog(BluetoothOperationMessage.readDescriptorValue.description + Symbols.whiteSpace + descriptor.uuid.uuidString, logType: .verbose, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
        peripheral.readValue(for: descriptor)
    }
    
    func writeDescriptor(_ peripheral: CBPeripheral, data: Data, descriptor: CBDescriptor)
    {
        logManager.addLog(BluetoothOperationMessage.writeDescriptor.description + Symbols.whiteSpace + descriptor.uuid.uuidString, logType: .verbose, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
        peripheral.writeValue(data, for: descriptor)
    }
    
    func setNotification(_ peripheral: CBPeripheral, isOn: Bool, characteristic: CBCharacteristic)
    {
        logManager.addLog(BluetoothOperationMessage.setNotificationForCharact.description + Symbols.whiteSpace + characteristic.uuid.uuidString, logType: .verbose, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
        peripheral.setNotifyValue(isOn, for: characteristic)
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        if let eRROOR = error
        {
            logManager.addLog(BluetoothOperationMessage.errorOccoursUpdateValueForDescriptor.description + Symbols.whiteSpace + descriptor.uuid.uuidString + Symbols.whiteSpace + eRROOR.localizedDescription, logType: .error, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
            deviceManagerDescriptorDelegate?.didUpdateValueDescriptor(descriptor, error: eRROOR as NSError?)
        }
        else if let _ = descriptor.value
        {
            logManager.addLog(BluetoothOperationMessage.successfulUpdateValueForDescriptor.description + Symbols.whiteSpace + descriptor.uuid.uuidString, logType: .debug, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
            deviceManagerDescriptorDelegate?.didUpdateValueDescriptor(descriptor, error: nil)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        if let eRROOR = error
        {
            logManager.addLog(BluetoothOperationMessage.errorOccoursWriteValueForDescriptor.description + Symbols.whiteSpace + descriptor.uuid.uuidString + Symbols.whiteSpace + eRROOR.localizedDescription, logType: .error, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
            deviceManagerDescriptorDelegate?.didWriteValueForDescriptor(descriptor, error: eRROOR as NSError?)
        }
        else if let _ = descriptor.value
        {
            logManager.addLog(BluetoothOperationMessage.successfulWriteValueForDescriptor.description + Symbols.whiteSpace + descriptor.uuid.uuidString, logType: .debug, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
            deviceManagerDescriptorDelegate?.didWriteValueForDescriptor(descriptor, error: nil)
        }
    }
    
    open func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        if let eRROR = error
        {
            logManager.addLog(BluetoothOperationMessage.errorOccoursDiscoverDescriptorsForCharact.description + Symbols.whiteSpace + characteristic.uuid.uuidString + Symbols.whiteSpace + eRROR.localizedDescription, logType: .error, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
        }
        if let _ = characteristic.value, let descriptors = characteristic.descriptors
        {
            for descriptor in descriptors
            {
                logManager.addLog(BluetoothOperationMessage.successfulDiscoverDescriptorsForCharact.description + Symbols.whiteSpace + characteristic.uuid.uuidString, logType: .debug, object: #function, session: BLESessionManager.getSession(deviceID: peripheral.identifier.uuidString)!)
                peripheral.readValue(for: descriptor)
            }
        }
    }
}
