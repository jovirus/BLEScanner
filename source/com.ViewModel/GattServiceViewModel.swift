//
//  GattServicePageViewModel.swift
//  MasterControlPanel
//
//  Created by JiajunQiu on 08/11/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//
import UIKit
import Foundation
import CoreBluetooth

internal class GattServiceViewModel: ViewModelBase {
   
    fileprivate(set) var selectedDevice: BLEDevice!
    fileprivate(set) var session: BLESession!
    
    var logManager = LogManager.instance
    
    enum ConnectButtonStatus : Int {
        case connect = 0
        case disconnect = 1
        case cancelConnection = 2
        
        func description() -> String {
            switch self {
                case .connect:
                    return "Connect"
                case .disconnect:
                    return "Disconnect"
                case .cancelConnection:
                    return "Cancel"
            }
        }
    }
    
    var listOfGattServiceViewCell: [GattServiceCellViewModel] = []
    var isInitialized: Bool!
    let estimatedRowHeight = CGFloat(100)
    var shouldShowDFUButton: Bool!
    var phoneStatusOnPeripheral: BLEConnectStatus!
    
    // consider the consequence that if the device is providing the same service and use the same UUID of a service, this faid
    func findCell(_ serviceUUID: CBUUID) -> GattServiceCellViewModel? {
        return self.findCell(serviceUUID, gattViewCell: self.listOfGattServiceViewCell)
    }
    
    func removeAllCellViewModel() {
        self.listOfGattServiceViewCell.removeAll()
    }
    
    func setSelectedDevice(_ device: BLEDevice, session: BLESession) {
        self.selectedDevice = device
        self.session = session
    }
    
    internal func updateSelectedDevice(_ device: BLEDevice) {
        self.selectedDevice = device
    }
    
    internal func checkDFUAvailable() -> Bool {
        var hasDFUService = false
        let securedDFU = findCell(GattServiceUUID.SecureDeviceFirmwareUpdate.AssignedNumber)
        let legacyDFU = findCell(GattServiceUUID.LegacyDeviceFirmwareUpdate.AssignedNumber)
        let buttonlessDFU = findCell(GattServiceUUID.ExperimentalButtonlessDFUService.AssignedNumber)
        if securedDFU != nil || legacyDFU != nil || buttonlessDFU != nil {
            hasDFUService = true
        }
        self.shouldShowDFUButton = hasDFUService
        return hasDFUService
    }
    
    func closeSession() {
        BLEDeviceManager.instance().disconnectPeriphral(BLEDeviceManager.instance().centralManager, peripheral: selectedDevice.cBPeripheral);
        if let records = logManager.getAllRecords(session: session) {
            _ = logManager.saveLog(content: records, session: session)
        }
        BLESessionManager.disposeSession(session: self.session)
        BLEDeviceManager.instance().discoverDevices()
    }
}
