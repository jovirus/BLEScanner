//
//  ScanningDevicePageViewModel.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 03/11/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

extension ScanningDevicePageCellViewModel {
    struct ManufacturerDataFormatation {
        private(set) var rawStringFormat: String = Symbols.NOT_AVAILABLE
        fileprivate(set) var rawData: Data? {
            didSet {
                guard let value = rawData else {
                    rawStringFormat = Symbols.NOT_AVAILABLE
                    clearFields()
                    return
                }
                rawStringFormat = DataConvertHelper.getNSData(value)
                tryGetiBeaconFormat(data: value)
                tryGetManufacturerData4_1Format(data: Array(value))
            }
        }
        private(set) var beaconDataFormat: iBeaconAdvertisementSpec!
        private(set) var manufacturerData4_1Spec: ManufacturerData4_1Spec!
        private(set) var beaconDataFormatedString = Symbols.NOT_AVAILABLE
        private(set) var manufactureData4_1FormatedString = Symbols.NOT_AVAILABLE
        private(set) var beaconName = Symbols.NOT_AVAILABLE
        
        init(manufactureData: Data?) {
            self.rawData = manufactureData
        }
        
        func shouldUpdate(newData: Data) -> Bool {
            guard let oldData = self.rawData, newData != oldData else { return true }
            return false
        }
        
        mutating func tryGetManufacturerData4_1Format(data: [UInt8]) {
            self.manufacturerData4_1Spec = ManufacturerData4_1Spec()
            let data: [UInt8] = Array(data)
            guard manufacturerData4_1Spec.copyToSpec(data: data) else {
                self.manufacturerData4_1Spec = nil
                return
            }
            manufactureData4_1FormatedString = manufacturerData4_1Spec.description()
        }
        
        mutating func tryGetiBeaconFormat(data: Data) {
            guard let result = BeaconHandler.getiBeaconFormatData(data) else {
                beaconDataFormat = nil
                return
            }
            self.beaconDataFormat = result
            beaconDataFormatedString = beaconDataFormat.description()
            beaconName = beaconDataFormat.getCompanyInfo().CompanyName
        }
        
        mutating private func clearFields() {
            beaconDataFormat = nil
            manufacturerData4_1Spec = nil
            beaconDataFormatedString = Symbols.NOT_AVAILABLE
            manufactureData4_1FormatedString = Symbols.NOT_AVAILABLE
            beaconName = Symbols.NOT_AVAILABLE
        }
    }
}

extension ScanningDevicePageCellViewModel {
    struct serviceDataFormatation {
        var data: ServiceDataCore5_0Spec! {
            didSet{
                guard data != nil, let bytes = self.data.data else {
                    clearFields()
                    return
                }
                self.rawStringFormat = DataConvertHelper.getNSData(bytes)
                tryGetServiceDataFormatation()
            }
        }
        private(set) var eddystoneFormation: EddystoneAdvertisementSpec!
        private(set) var rawStringFormat = Symbols.NOT_AVAILABLE
        private(set) var eddystoneFormatedString = Symbols.NOT_AVAILABLE
        private(set) var beaconName = Symbols.NOT_AVAILABLE
        
        init(serviceData: NSDictionary) {
            self.data = DataConvertHelper.getServiceData(serviceData)
        }
        
        mutating func tryGetServiceDataFormatation() {
            guard let result = BeaconHandler.getEddyStoneBeaconFormatData(self.data) else { return }
            eddystoneFormation = result
            eddystoneFormatedString = result.description()
            beaconName = eddystoneFormation.beaconName
        }
        
        mutating private func clearFields() {
            eddystoneFormation = nil
            rawStringFormat = Symbols.NOT_AVAILABLE
            eddystoneFormatedString = Symbols.NOT_AVAILABLE
            beaconName = Symbols.NOT_AVAILABLE
        }
    }
}

class ScanningDevicePageCellViewModel: ScanningPageViewModel {
    var deviceID: String = Symbols.NOT_AVAILABLE
    var deviceName: String = Symbols.NOT_AVAILABLE
    var connectionStatus: String = ""
    var rssi: String {
        get {
            guard let value = rssiValue else {
                return Symbols.NOT_AVAILABLE
            }
            return String(value) + Symbols.whiteSpace + Symbols.dBm
        }
    }
    private(set) var rssiValue: Int!
    var completeLocalName: String = Symbols.NOT_AVAILABLE
    var manufacturerData: ManufacturerDataFormatation!
    var isConnectable: Bool?
    var txPowerLevel: String {
        didSet {
            guard txPowerLevel != Symbols.NOT_AVAILABLE else { return }
            return txPowerLevel += Symbols.dBm
        }
    }
    private(set) var solicitedServiceUUIDString: String = Symbols.NOT_AVAILABLE
    private(set) var solicitedServiceUUID: [GattUUID] = [] {
        didSet {
            guard solicitedServiceUUID.count > 0 else {
                solicitedServiceUUIDString = Symbols.NOT_AVAILABLE
                return
            }
            var temp = ""
            for item in solicitedServiceUUID {
                temp += item.AssignedNumber.uuidString + Symbols.comma
            }
        }
    }
    var serviceUUID: [GattUUID] = []
    var serviceData: serviceDataFormatation!
    var overflowServiceUUID : [GattUUID] = []
    var bleDevice: BLEDevice!
    
    var interval: String {
        get {
            guard let value = self.timeIntervalSinceFirstDiscovered else {
                return Symbols.NOT_AVAILABLE
            }
            return String(Int(value)) + Symbols.whiteSpace + Symbols.millisecond
        }
    }
    private var timeIntervalSinceFirstDiscovered: Double!
    //after pause of scanning, the time interval need to be recalculated. and all device are out of reach
    var isValidatedInterval: Bool = true
    var isDeviceOutOfRange: Bool = false
    
    init(device: BLEDevice, displayColor: UIColor) {
        self.deviceID = device.deviceID
        self.connectionStatus = device.connectionStatus.description()
        self.rssiValue = device.rssiValue
        self.completeLocalName = device.advertisementPackage.cBAdvertisementDataLocalName
        self.deviceName = device.advertisementPackage.cBAdvertisementDataLocalName
        self.manufacturerData = ManufacturerDataFormatation(manufactureData: device.advertisementPackage.cBAdvertisementDataManufacturerData)
        if self.manufacturerData.beaconName != Symbols.NOT_AVAILABLE { self.deviceName = self.manufacturerData.beaconName }
        self.deviceName = self.manufacturerData.beaconName == Symbols.NOT_AVAILABLE ? device.deviceName : self.manufacturerData.beaconName
        self.isConnectable = device.advertisementPackage.cBAdvertisementDataIsConnectable
        self.txPowerLevel = device.advertisementPackage.cBAdvertisementDataTxPowerLevel
        self.solicitedServiceUUID = device.advertisementPackage.cBAdvertisementDataSolicitedServiceUUIDs
        self.serviceUUID = device.advertisementPackage.cBAdvertisementDataServiceUUIDs
        self.serviceData = serviceDataFormatation(serviceData: device.advertisementPackage.cBAdvertisementDataServiceData)
        if self.serviceData.beaconName != Symbols.NOT_AVAILABLE { self.deviceName = self.serviceData.beaconName }
        self.overflowServiceUUID = device.advertisementPackage.cBAdvertisementDataOverflowServiceUUIDs
        super.init()
        self.displayColor = displayColor
        self.bleDevice = device
    }
    
    @discardableResult
    func updateDevice(_ device: BLEDevice, displayColor: UIColor) -> ScanningDevicePageCellViewModel
    {
        self.connectionStatus = device.connectionStatus.description()
        if device.rssi == Symbols.outOfRangeRSSI {
            self.isDeviceOutOfRange = true
        } else {
            self.rssiValue = device.rssiValue
            self.isDeviceOutOfRange = false
        }
        self.completeLocalName = device.advertisementPackage.cBAdvertisementDataLocalName
        self.deviceName = device.advertisementPackage.cBAdvertisementDataLocalName
        self.manufacturerData.rawData = device.advertisementPackage.cBAdvertisementDataManufacturerData
        if self.manufacturerData.beaconName != Symbols.NOT_AVAILABLE { self.deviceName = self.manufacturerData.beaconName }
        self.isConnectable = device.advertisementPackage.cBAdvertisementDataIsConnectable
        self.txPowerLevel = device.advertisementPackage.cBAdvertisementDataTxPowerLevel
        self.solicitedServiceUUID = device.advertisementPackage.cBAdvertisementDataSolicitedServiceUUIDs
        self.serviceUUID = device.advertisementPackage.cBAdvertisementDataServiceUUIDs
        self.serviceData.data = DataConvertHelper.getServiceData(device.advertisementPackage.cBAdvertisementDataServiceData)
        if self.serviceData.beaconName != Symbols.NOT_AVAILABLE { self.deviceName = self.serviceData.beaconName }
        self.overflowServiceUUID = device.advertisementPackage.cBAdvertisementDataOverflowServiceUUIDs
        //when user pause the scan or it went suspend mode it will become an invalide interval
        if self.isValidatedInterval {
            var interval = Double(device.createdAt.timeIntervalSince(self.bleDevice.createdAt))
            self.timeIntervalSinceFirstDiscovered = (interval.roundToPlaces(3)) * 1000
        } else {
            self.timeIntervalSinceFirstDiscovered = nil
            self.bleDevice.createdAt = device.createdAt
            self.isValidatedInterval = true
        }
        self.displayColor = displayColor
        self.bleDevice.update(newBLEDevice: device)
        return self
    }
    
    static func getIsConnectableStringValue(_ value: Bool?) -> String {
        var stringValue: String = ""
        if let result = value {
            stringValue = String(result)
        } else {
            stringValue = Symbols.NOT_AVAILABLE
        }
        return stringValue
    }
    
    func getServiceUUID() -> String {
        guard self.serviceUUID.count > 0 else { return Symbols.NOT_AVAILABLE }
        var result = ""
        for item in self.serviceUUID {
            result += item.description() + Symbols.semicolon
        }
        return result
    }
    
    func getOverflowUUIDs() -> String {
        guard self.overflowServiceUUID.count > 0 else {
            return Symbols.NOT_AVAILABLE
        }
        var result = ""
        for item in self.overflowServiceUUID {
            result += item.description() + Symbols.semicolon
        }
        return result
    }
}
