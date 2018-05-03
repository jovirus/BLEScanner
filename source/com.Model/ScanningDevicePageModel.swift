//
//  ScanningDevicePageModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 19/07/16.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import CoreBluetooth

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

open class ScanningDevicePageModel {
    //static var instance = ScanningDevicePageModel()
    fileprivate var filteredList: [String] = []
    var isOnFilterMode = false
}

extension ScanningDevicePageModel {
    static var instance = ScanningDevicePageModel()
    func createSession(deviceID: String, deviceName: String, peripheralConnectionStatus: BLEConnectStatus) -> BLESession {
        return BLESessionManager.createSession(forDevice: deviceID, deviceName: deviceName, peripheralConnectionStatus: peripheralConnectionStatus)
    }
}

extension ScanningDevicePageModel {
    
    fileprivate func shouldShowDeviceForFilter2(_ filters: DeviceFilterViewModel, device: ScanningDevicePageCellViewModel) -> Bool {
        var shouldShowDevice = false
        
        guard filters.advFilters.count > 0 else {
            shouldShowDevice = true
            return shouldShowDevice
        }
        
        for (key, value) in filters.advFilters {
            switch key {
                case CBAdvertisementDataLocalNameKey:
                    guard let filterValue = value.first, let nameFilter = filterValue as? String, device.deviceName.containsIgnoringCase(nameFilter) else { return shouldShowDevice }
                    continue
                case CBAdvertisementDataUUIDsFilterKey:
                    switch filters.deviceTypeFilter {
                        case .Eddystone:
                            guard let format = device.serviceData.eddystoneFormation, format.isEddystoneBeacon() else { return shouldShowDevice }
                            continue
                        case .PhysicalWeb:
                            guard let format = device.serviceData.eddystoneFormation, format.isEddystoneBeacon(), Mirror(reflecting: device.serviceData.eddystoneFormation).subjectType == EddystoneURLSpec.self else { return shouldShowDevice }
                            continue
                        case .SecureDFU:
                            guard device.serviceUUID.contains(where: { $0 == GattServiceUUID.SecureDeviceFirmwareUpdate }) else { return shouldShowDevice }
                            continue
                        case .LegacyDFU:
                            guard device.serviceUUID.contains(where: { $0 == GattServiceUUID.LegacyDeviceFirmwareUpdate }) else { return shouldShowDevice }
                            continue
                        case .Thingy:
                            guard device.serviceUUID.contains(where: { $0 == GattServiceUUID.ThingyConfigurationService }) else { return shouldShowDevice }
                            continue
                        case .nRFBeacon:
                            guard let spec = device.manufacturerData.beaconDataFormat, spec.getCompanyInfo().HexaValue == "0x0059" else { return shouldShowDevice }
                            continue
                        case .None:
                            shouldShowDevice = true
                            continue
                }
                case CBAdvertisementSignalStrength:
                    guard let filterValue = value.first, let rssiValue = filterValue as? Float else { return shouldShowDevice }
                    guard Float(device.rssiValue) >= rssiValue else { return shouldShowDevice }
                    continue
                case CBFavoriteDeviceFilterKey:
                    guard filters.favourite.contains(device.deviceID) else { return shouldShowDevice }
                    continue
                default: break
            }
        }
        shouldShowDevice = true
        return shouldShowDevice
    }
    
    func isDeviceSatisfiedForFilter (_ filters: DeviceFilterViewModel, device: ScanningDevicePageCellViewModel) -> Bool {
        var satisfiedForFavouriteFilter = true
        if filters.showOnlyFavourite, !filters.favourite.contains(device.deviceID) { satisfiedForFavouriteFilter = false }
        guard satisfiedForFavouriteFilter, shouldShowDeviceForFilter2(filters, device: device) else { return false }
        addNewFilteredDevice(device.deviceID)
        return true
    }
    
    open func getFilteredDevice() -> [String] {
        return self.filteredList
    }
    
    open func removeFromFilter(_ deviceID: String) {
        if let index = self.filteredList.index(of: deviceID) {
            self.filteredList.remove(at: index)
        }
    }
    
    open func clearFilteredDevice() {
        self.filteredList.removeAll()
    }
    
    func isMatchedDeviceForFilter(_ deviceID: String) -> Bool {
        if self.filteredList.contains(deviceID) {
            return true
        } else
        {
            return false
        }
    }
    
    fileprivate func addNewFilteredDevice(_ deviceID: String) {
        if !self.filteredList.contains(deviceID) {
            self.filteredList.append(deviceID)
        }
    }
}
