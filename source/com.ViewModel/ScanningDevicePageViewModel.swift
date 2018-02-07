//
//  ScanningDevicePageViewModel.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 03/11/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import UIKit
import Foundation
protocol ScanningPageUpdatedDelegate {
     func didUpdateScanningPage(_ device: ScanningDevicePageCellViewModel)
     func didRefreshScanningPage(_ isFreshed: Bool)
}

protocol ScanButtonSuspendedDelegate {
    func didScanButtonSuspended()
}

extension ScanningDevicePageViewModel: BLEDeviceManagerAdvertisementDelegate {
    func didReceiveAdvertisementPackage(_ newDevice: BLEDevice) {
        guard newDevice.rssi != Symbols.outOfRangeRSSI else { return }
        if let indexOfExistingDevice = findStaticCellViewModel(newDevice.deviceID) {
            let displayColor = getDeviceColor(self.advertisingDevices[indexOfExistingDevice].deviceID)
            self.advertisingDevices[indexOfExistingDevice].updateDevice(newDevice, displayColor: displayColor)
            scanningPageUpdatedDelegate?.didUpdateScanningPage(self.advertisingDevices[indexOfExistingDevice])
        } else {
            var cellVM: ScanningDevicePageCellViewModel!
            let displayColor = UIHelper.getSequencedDeviceColorTag()
            cellVM = ScanningDevicePageCellViewModel(device: newDevice, displayColor: displayColor)
            registerDeviceColor(newDevice.deviceID, displayColor: displayColor)
            advertisingDevices.append(cellVM)
            scanningPageUpdatedDelegate?.didUpdateScanningPage(cellVM)
        }
    }
    
    func findStaticCellViewModel(_ deviceID: String) -> Int? {
        return self.advertisingDevices.index(where: { (device) -> Bool in return device.deviceID == deviceID })
    }
    
    fileprivate func getDeviceColor(_ deviceID: String) -> UIColor {
        var color: UIColor!
        if self.deviceColor[deviceID] != nil {
            color = self.deviceColor[deviceID]
        }
        return color
    }
    
    fileprivate func registerDeviceColor(_ deviceID: String, displayColor: UIColor) {
        deviceColor[deviceID] = displayColor
    }
}

extension ScanningDevicePageViewModel {
        enum ScanState: Int {
            case scanning = 0
            case offScan = 1
            case suspending = 2 //When ison scanning mode and bluetooth hardware is off, this mode can resume to scanning state
            
            func description() -> String {
                switch self {
                case .scanning:
                    return "STOP SCANNING"
                case .offScan:
                    return "SCAN"
                case .suspending:
                    return "SUSPENDED"
                }
            }
        }
    }

open class ScanningDevicePageViewModel: ViewModelBase {
    var deviceTableCellViewModelList: [ScanningDevicePageCellViewModel] = []
    fileprivate var advertisingDevices: [ScanningDevicePageCellViewModel] = []
    fileprivate var scanningDeviceModel = ScanningDevicePageModel.instance
    
    var scanningPageUpdatedDelegate: ScanningPageUpdatedDelegate!
    var scanningPageStatusDelegate: ScanButtonSuspendedDelegate!
    //Create a sessopm when a device is connecting.
    var selectedCellVM: ScanningDevicePageCellViewModel!
    //deviceid is the key and the randon picked color is value
    var deviceColor: Dictionary<String, UIColor> = Dictionary()
    
    // default is Scanning
    fileprivate(set) var scanButtonStatus: ScanState = .scanning
    
    let CONNECTABLE = DeviceConnectionType.connectable.description()
    let NON_CONNECTABLE = DeviceConnectionType.non_connectable.description()
        
    let maxHeight = CGFloat(320)
    let minHeight = CGFloat(80)
    
    var filterViewExpaned: CGFloat = 220
    var filterViewLimited: CGFloat = 49
    
    let timeToRenderTheDeviceTableSecond = TimeInterval(0.8)
    fileprivate(set) var isOnDragging = false
    fileprivate(set) var isOnDecelerating = false
    var filterSettings = DeviceFilterViewModel()
    
    //static var instance = ScanningDevicePageViewModel()
    override init() {
        super.init()
        BLEDeviceManager.instance().registerDelegate(String(describing: ScanningDevicePageViewModel.self), receiver: self)
    }
    
    func setDraggingStatus(isOnDragging: Bool) {
        self.isOnDragging = isOnDragging
    }
    
    func setDeceleratingStatus(isOnDecelerating: Bool) {
        self.isOnDecelerating = isOnDecelerating
    }
    
    func isTableViewScrolling()-> Bool {
        if self.isOnDragging && self.isOnDecelerating {
            return true
        } else if self.isOnDragging && !self.isOnDecelerating {
            return true
        } else if !self.isOnDragging && !self.isOnDecelerating {
            return false
        } else if !self.isOnDragging && self.isOnDecelerating {
            return true
        } else {
            return false
        }
    }
    
    func isOnScanningState() -> Bool {
        return self.scanButtonStatus == .scanning
    }
    
    func changeScanButtonStatusTo(_ state: ScanState) {
        self.scanButtonStatus = state
    }
    
    //Pause the date object in each scanned device
    func pauseAdvertiserTimeTracker() {
        self.advertisingDevices.forEach { (device) in
            device.isValidatedInterval = false
        }
        self.deviceTableCellViewModelList.forEach { (device) in
            device.isValidatedInterval = false
        }
    }
    
    func BleHardwareStatusChanged(_ isBluetoothHardwareOn: Bool) -> ScanState {
        if scanButtonStatus == ScanState.scanning && !isBluetoothHardwareOn {
            changeScanButtonStatusTo(ScanState.suspending)
            scanningPageStatusDelegate?.didScanButtonSuspended()
        } else if scanButtonStatus == ScanState.offScan && !isBluetoothHardwareOn {
            //Do Nothing
            changeScanButtonStatusTo(ScanState.suspending)
            scanningPageStatusDelegate?.didScanButtonSuspended()
        } else if self.scanButtonStatus == ScanState.suspending && isBluetoothHardwareOn
        {
            changeScanButtonStatusTo(ScanState.offScan)
        } else if scanButtonStatus == ScanState.offScan && isBluetoothHardwareOn {
            changeScanButtonStatusTo(ScanState.offScan)
        }
        return self.scanButtonStatus
    }
    
    func BuildDeviceTableCellViewModel() {
        if self.scanningDeviceModel.isOnFilterModel {
            self.deviceTableCellViewModelList.removeAll()
            for item in self.advertisingDevices
            {
                var copyCellVM: ScanningDevicePageCellViewModel!
                copyCellVM = item
                if self.scanningDeviceModel.shouldShowDeviceForFilter(self.filterSettings, device: copyCellVM) {
                    self.deviceTableCellViewModelList.append(copyCellVM)
                } else {
                    //ignor
                }
            }
        }
        else {
            self.updateDeviceTableCellViewModelList()
        }
    }
    
    private func updateDeviceTableCellViewModelList() {
        for item in self.advertisingDevices {
            guard !item.isDeviceOutOfRange else {
                continue
            }
            guard let index = self.deviceTableCellViewModelList.index(where: { (uiDevice) -> Bool in
                uiDevice.deviceID == item.deviceID
            }) else {
                self.deviceTableCellViewModelList.append(item)
                continue
            }
            self.deviceTableCellViewModelList[index] = item
        }
    }
    
    func shouldFilterStaticPage() -> Bool {
        var shouldFilterStaticPage = false
        if scanButtonStatus == ScanState.offScan || scanButtonStatus == ScanState.suspending {
            shouldFilterStaticPage = true
        }
        return shouldFilterStaticPage
    }
    
    //MARK: - UI update, when fresh on UI
    func freshLocalList()
    {
        self.deviceTableCellViewModelList.removeAll()
        //when is on scanning, all non detected advertiser should be removed
        if self.scanButtonStatus == .scanning {
            for index in 0..<self.advertisingDevices.count {
                guard self.advertisingDevices[index].isValidatedInterval else {
                    self.advertisingDevices[index].isDeviceOutOfRange = true
                    continue
                }
            }
        }
        //self.deviceColor.removeAll()
        //UIHelper.resetColorCounter()
        scanningPageUpdatedDelegate?.didRefreshScanningPage(true)
    }
    
    // when clear all filter on UI
    func turnOffDeviceFilters() {
        self.filterSettings.clearFilter()
        self.scanningDeviceModel.clearFilteredDevice()
        scanningDeviceModel.isOnFilterModel = false
    }
    
    //When user change filter criterias
    func setNewDeviceFilter() {
        self.filterSettings.clearFilter()
        self.scanningDeviceModel.clearFilteredDevice()
    }
    
    //before filter label display
    func isFilterValidated() -> Bool{
        if self.filterSettings.isFilterOn() {
            scanningDeviceModel.isOnFilterModel = true
        } else {
            scanningDeviceModel.isOnFilterModel = false
        }
        return scanningDeviceModel.isOnFilterModel
    }
    
    func resetDeviceNameFilter() {
        self.filterSettings.nameFilter = ""
    }
    
    //When user update the favourite list at runtime
    func removeFromFavouriteList(_ deviceID: String) {
        if scanningDeviceModel.isOnFilterModel && self.filterSettings.showOnlyFavourite && self.filterSettings.favourite.contains(deviceID)
        {
            self.filterSettings.removeFromFavourite(deviceID)
            self.scanningDeviceModel.removeFromFilter(deviceID)
        }
    }
    
//    //reset filter label
//    func resetFilterLabel() -> String {
//        self.filterSettings.resetFilterStringText()
//        return filterSettings.filtersTextDescription
//    }
    
    func createSession() -> BLESession {
       return scanningDeviceModel.createSession(deviceID: selectedCellVM.deviceID, deviceName: selectedCellVM.deviceName, peripheralConnectionStatus: selectedCellVM.bleDevice.connectionStatus)
    }
}
