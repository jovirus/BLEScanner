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
        var hasMultiFormation: Bool = false

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
            hasMultiFormation = true
        }
        
        mutating func tryGetiBeaconFormat(data: Data) {
            guard let result = BeaconHandler.getiBeaconFormatData(data) else {
                beaconDataFormat = nil
                return
            }
            self.beaconDataFormat = result
            beaconDataFormatedString = beaconDataFormat.description()
            beaconName = beaconDataFormat.getCompanyInfo().CompanyName
            hasMultiFormation = true
        }
        
        mutating private func clearFields() {
            beaconDataFormat = nil
            manufacturerData4_1Spec = nil
            beaconDataFormatedString = Symbols.NOT_AVAILABLE
            manufactureData4_1FormatedString = Symbols.NOT_AVAILABLE
            beaconName = Symbols.NOT_AVAILABLE
            hasMultiFormation = false
        }
    }
}

extension ScanningDevicePageCellViewModel {
    struct serviceDataFormatation {
        var data: [ServiceDataCore5_0Spec] {
            didSet{
                guard data.count > 0 else {
                    setDefaultFields()
                    return
                }
                self.rawStringFormat = ""
                for spec in data {
                    self.rawStringFormat += spec.description() + Symbols.whiteSpace
                }
                if data.count == 1 {
                    tryGetEddytoneFormatation()
                }
            }
        }
        private(set) var eddystoneFormation: EddystoneAdvertisementSpec!
        private(set) var rawStringFormat = Symbols.NOT_AVAILABLE
        private(set) var eddystoneFormatedString = Symbols.NOT_AVAILABLE
        private(set) var beaconName = Symbols.NOT_AVAILABLE
        var hasMultiFormation: Bool = false
        
        init(serviceData: NSDictionary) {
            self.data = DataConvertHelper.getServiceData(serviceData)
        }
        
        mutating func tryGetEddytoneFormatation() {
            guard self.data.count == 1, let result = BeaconHandler.getEddyStoneBeaconFormatData(self.data[0]) else { return }
            eddystoneFormation = result
            eddystoneFormatedString = result.description()
            rawStringFormat = DataConvertHelper.getNSData(self.data[0].data!)
            beaconName = eddystoneFormation.beaconName
            hasMultiFormation = true
        }
        
        mutating private func setDefaultFields() {
            hasMultiFormation = false
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
    var serviceUUIDDescription: String = Symbols.NOT_AVAILABLE
    var serviceData: serviceDataFormatation!
    var overflowServiceUUID : [GattUUID] = []
    var overflowServiceUUIDDescription: String = Symbols.NOT_AVAILABLE
    
    var bleDevice: BLEDevice!
    var interval: String {
        get {
            guard self.timeIntervalSinceLastDiscovered != 0 else {
                return Symbols.NOT_AVAILABLE
            }
            return String(format: "%0.0f", self.timeIntervalSinceLastDiscovered) + Symbols.whiteSpace + Symbols.millisecond
        }
    }
    private var timeIntervalSinceLastDiscovered: Double = 0
    private var intervalCount: Int = 0
    //after pause of scanning, the time interval need to be recalculated. and all device are set to out of reach
    var isValidatedInterval: Bool = true
    var isDeviceOutOfRange: Bool = false
    var isSatisfiedForFilter: Bool = true
    var isVisualized: Bool = false
    
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
        if self.serviceUUID.count > 0 { self.serviceUUIDDescription = ScanningDevicePageCellViewModel.getUUIDsString(uuids: serviceUUID) }
        self.serviceData = serviceDataFormatation(serviceData: device.advertisementPackage.cBAdvertisementDataServiceData)
        if self.serviceData.beaconName != Symbols.NOT_AVAILABLE { self.deviceName = self.serviceData.beaconName }
        self.overflowServiceUUID = device.advertisementPackage.cBAdvertisementDataOverflowServiceUUIDs
        if self.overflowServiceUUID.count > 0 { self.overflowServiceUUIDDescription = ScanningDevicePageCellViewModel.getUUIDsString(uuids: overflowServiceUUID) }
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
            var timeDiffer = device.createdAt.timeIntervalSince(self.bleDevice.createdAt)
            let milliSecond = timeDiffer.roundToPlaces(3) * 1e3
            self.timeIntervalSinceLastDiscovered = setBroadcastingInterval(timeDifferMilliSec: milliSecond)
        } else {
            self.timeIntervalSinceLastDiscovered = 0
            self.isValidatedInterval = true
        }
        self.displayColor = displayColor
        self.bleDevice.update(newBLEDevice: device)
        return self
    }
    
    /**
        This method is developed to measure approximate. interval of a peripheral.
        ref: https://developer.apple.com/library/content/qa/qa1931/_index.html
        *This method will ignore channel hopping 1.25ms between each channel i.e 3ms
        *This method will assume the min interval 20ms. Considering apple´s guidline shall interval Min >= 15ms, with +/-5 difference
        The calculation is based on the last interval and a new interval. Three situations are discussed.
        1. The incoming interval value is close to last interval, with a allowed inaccuracy +/-5ms.
        2. The incoming interval value is at least 2.4x advanced than last interval. Given limit value 20ms, min:48ms/max:20ms; constant: 2.4, and less than 6x Max difference
        2.1 return of a weighted arithmetic mean
        3. The stored interval value is 1.75x higher than incoming interval, but still no more than 6x, the absolute value of reminder shall less than 25% after exactly divides.
        4. When the newer interval is significantly less than stored value, it shall be considered correct value.
     
        @param new interval since last time captured, described in millisecond
        @return corrected interval value after algrithom evaluation
     */
    func setBroadcastingInterval(timeDifferMilliSec: Double) -> Double {
        guard timeDifferMilliSec >= 15 else {
            return self.timeIntervalSinceLastDiscovered
        }
        if self.timeIntervalSinceLastDiscovered == 0 { return timeDifferMilliSec }
        if self.timeIntervalSinceLastDiscovered - 5 < timeDifferMilliSec && timeDifferMilliSec <= self.timeIntervalSinceLastDiscovered + 5 {
            return (self.timeIntervalSinceLastDiscovered * 9 + timeDifferMilliSec) / 10
        } else if (timeDifferMilliSec / self.timeIntervalSinceLastDiscovered) >= 2.4, (timeDifferMilliSec / self.timeIntervalSinceLastDiscovered) < 6 {
            let correctLessInterval = timeDifferMilliSec - floor((timeDifferMilliSec / self.timeIntervalSinceLastDiscovered)) * 3
            let times1 = (correctLessInterval / self.timeIntervalSinceLastDiscovered).rounded()
            return ((correctLessInterval / times1) + self.timeIntervalSinceLastDiscovered * 29) / 30
        } else if (self.timeIntervalSinceLastDiscovered / timeDifferMilliSec) > 1.75, (self.timeIntervalSinceLastDiscovered / timeDifferMilliSec) <= 6, abs((self.timeIntervalSinceLastDiscovered / timeDifferMilliSec).remainder(dividingBy: 1)) <= 0.25 {
            let times2 = (self.timeIntervalSinceLastDiscovered / timeDifferMilliSec)
            return (timeDifferMilliSec * times2) * 29 + self.timeIntervalSinceLastDiscovered / 30
        } else if (self.timeIntervalSinceLastDiscovered / timeDifferMilliSec) > 6 {
            return timeDifferMilliSec
        }
        return self.timeIntervalSinceLastDiscovered
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
    
    static func getUUIDsString(uuids: [GattUUID]) -> String {
        guard uuids.count > 0 else { return Symbols.NOT_AVAILABLE }
        var result = ""
        for item in uuids {
            result += item.description()
        }
        return result
    }
}
