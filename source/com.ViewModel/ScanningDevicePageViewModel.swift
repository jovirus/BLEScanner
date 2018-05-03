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
    fileprivate(set) var scanningDeviceModel = ScanningDevicePageModel.instance
    
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
        
    let maxHeight = CGFloat(200)
    let defaulHeight = CGFloat(80)
    let miniHeight = CGFloat(0)
    
    var filterViewExpaned: CGFloat = 220
    var filterViewLimited: CGFloat = 49
    
    let timeToRenderTheDeviceTableSecond = TimeInterval(1.2)
    fileprivate(set) var isOnDragging = false
    fileprivate(set) var isOnDecelerating = false
    var didDataSourceChanged = false
    var filterSettings = DeviceFilterViewModel()
    
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
    
    /**
        return bool. Indicate whether need to reload the tableview
     */
    func BuildDeviceTableCellViewModel() {
        validateInterval()
        self.updateDeviceTableCellViewModelList(shouldApplyFilter: self.scanningDeviceModel.isOnFilterMode)
    }
    
    /**
        If device have not been updated more than 6 sec, if will be considered out of range
        ref: https://developer.apple.com/library/content/qa/qa1931/_index.html
     */
    private func validateInterval() {
        for item in self.advertisingDevices {
            if Date().timeIntervalSince(item.bleDevice.createdAt) > 6 {
                item.isDeviceOutOfRange = true
            }
        }
    }
    
    private func updateDeviceTableCellViewModelList(shouldApplyFilter: Bool) {
        for item in self.advertisingDevices {
            let isSatisfied = self.scanningDeviceModel.isDeviceSatisfiedForFilter(self.filterSettings, device: item)
            if shouldApplyFilter, isSatisfied, let index = self.deviceTableCellViewModelList.index(where: {$0.deviceID == item.deviceID}) {
                self.deviceTableCellViewModelList[index] = item
            } else if !shouldApplyFilter, let index = self.deviceTableCellViewModelList.index(where: {$0.deviceID == item.deviceID})  {
                self.deviceTableCellViewModelList[index] = item
            } else if shouldApplyFilter && isSatisfied {
                self.deviceTableCellViewModelList.append(item)
            } else if !shouldApplyFilter {
                self.deviceTableCellViewModelList.append(item)
            }
        }
        if shouldApplyFilter {
            for item in self.deviceTableCellViewModelList {
                item.isSatisfiedForFilter = self.scanningDeviceModel.isDeviceSatisfiedForFilter(self.filterSettings, device: item)
            }
        } else {
            self.deviceTableCellViewModelList.forEach({ $0.isSatisfiedForFilter = true })
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
    func clearDataSource() {
        self.deviceTableCellViewModelList.removeAll()
        self.advertisingDevices.forEach({ $0.isPushedToView = false })
        self.didDataSourceChanged = true
    }
    
    func freshLocalList() {
        self.advertisingDevices.removeAll()
        self.deviceTableCellViewModelList.removeAll()
        self.didDataSourceChanged = true
        scanningPageUpdatedDelegate?.didRefreshScanningPage(true)
    }
    
    // when clear all filter on UI
    func turnOffDeviceFilters() {
        guard self.scanningDeviceModel.isOnFilterMode else { return }
        self.filterSettings.clearFilter()
        self.scanningDeviceModel.clearFilteredDevice()
        scanningDeviceModel.isOnFilterMode = false
        self.didDataSourceChanged = true
    }
    
    //When user change filter criterias
    func setNewDeviceFilter() {
        self.filterSettings.clearFilter()
        self.scanningDeviceModel.clearFilteredDevice()
    }
    
    //before filter label display
    func isFilterValidate() -> Bool {
        if self.filterSettings.isFilterOn() {
            scanningDeviceModel.isOnFilterMode = true
        } else {
            scanningDeviceModel.isOnFilterMode = false
        }
        return scanningDeviceModel.isOnFilterMode
    }
    
    func resetDeviceNameFilter() {
        self.filterSettings.nameFilter = ""
    }
    
    //When user update the favourite list at runtime
    func removeFavroutiteDeviceFromFilterList(_ deviceID: String) -> Bool {
        guard scanningDeviceModel.isOnFilterMode && self.filterSettings.showOnlyFavourite && self.filterSettings.favourite.contains(deviceID), let index = self.deviceTableCellViewModelList.index(where: { $0.deviceID == deviceID }) else {
            return false
        }
        self.filterSettings.removeFromFavourite(deviceID)
        self.scanningDeviceModel.removeFromFilter(deviceID)
        self.deviceTableCellViewModelList[index].isSatisfiedForFilter = false
        return true
    }
    
    func createSession() -> BLESession {
       return scanningDeviceModel.createSession(deviceID: selectedCellVM.deviceID, deviceName: selectedCellVM.deviceName, peripheralConnectionStatus: selectedCellVM.bleDevice.connectionStatus)
    }
}
