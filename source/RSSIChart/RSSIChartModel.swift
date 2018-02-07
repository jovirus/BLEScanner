//
//  RSSIChartModel.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 27/05/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation

protocol  RSSIChartModelDelegate {
    // dinactionary a deviceID with its average rssi at a given timeslot
    func didRSSIAverageValueGenerated(_ RSSIAverage: Dictionary<String, RSSIChartDataSetViewModel>, count: Int, needRefreshAll: Bool)
    func didScanningActionChanged(_ isScanningOn: Bool)
}

protocol RSSIChartModelProtocol {
    init(timeSlotSec: Int, isNormalizedRSSI: Bool)
}

extension RSSIChartModel: ScanningPageUpdatedDelegate {
    func didUpdateScanningPage(_ device: ScanningDevicePageCellViewModel) {
        guard isAdvPackageSwitchOn, let data = getCalibrationData(device.bleDevice) else { return }
        data.displayColor = device.displayColor
        if (self.rawAdvPackage[device.deviceID]) != nil {
            self.rawAdvPackage[device.deviceID]?.append(data)
        } else {
            self.rawAdvPackage[device.deviceID] = [data]
        }
    }
    
    func didRefreshScanningPage(_ isFreshed: Bool) {
        // close the receiver
        isAdvPackageSwitchOn = false
        //stop the timer
        stopTimer()
        // clear the dictionary
        RSSIAverage.removeAll()
        rawAdvPackage.removeAll()
        counter = 1
        //Notify the view model
        rssiChartModelDelegate?.didRSSIAverageValueGenerated(RSSIAverage, count: counter, needRefreshAll: true)
        if isScanningOn {
            //Open up the receiver
            isAdvPackageSwitchOn = true
            // open the timer
            startDataCollector()
        } else
        {
            return
        }
    }
}

class RSSIChartModel: BLEDeviceManagerScanningActionDelegate, RSSIChartModelProtocol
{
    // this is configerable  1 - 5 sec, 4 sec as default
    var dataIntervalInSecond = TimeInterval(4)
    // This is the average value in a set interval after deviceID is key
    var RSSIAverage: Dictionary<String, RSSIChartDataSetViewModel> = Dictionary()
    // Is using normalization 
    var shouldCalibrateRSSI: Bool = false
    //Raw advertisement package
    fileprivate var rawAdvPackage: Dictionary<String, [CalibrationData]> = Dictionary()
    
    //Adv package sender counter with interval
    fileprivate var counter = 1
    fileprivate var interval: Int = 1
    
    //Timer to collect data
    fileprivate var isAdvDataCollectorTimerRunning: Bool = false
    fileprivate var dispatchDataCollectorTimer = Timer()
    fileprivate var isAdvPackageSwitchOn = true
    
    var rssiChartModelDelegate: RSSIChartModelDelegate!
    //This should be the same object used in scanning view controller
    var scanningDevicePageVM: ScanningDevicePageViewModel!
    var isScanningOn: Bool = true
    
    required init(timeSlotSec: Int, isNormalizedRSSI: Bool)
    {
        self.dataIntervalInSecond = TimeInterval(timeSlotSec)
        self.interval = timeSlotSec
        self.shouldCalibrateRSSI = isNormalizedRSSI
    }
    
    func initializeChartModel (viewModel: ScanningDevicePageViewModel) {
        self.scanningDevicePageVM = viewModel
        scanningDevicePageVM.scanningPageUpdatedDelegate = self
        BLEDeviceManager.instance().deviceManagerScanningActionDelegate = self
        guard !isAdvDataCollectorTimerRunning else {
            return
        }
        startDataCollector()
    }
    
    func didScanningActionChanged(_ isScanningOn: Bool) {
        if !isScanningOn {
            stopAdvDataCollector()
        } else
        {
            startAdvDataCollector()
        }
        self.isScanningOn = isScanningOn
        rssiChartModelDelegate?.didScanningActionChanged(isScanningOn)
    }
    
    func stopAdvDataCollector() {
        self.isAdvPackageSwitchOn = false
        self.isAdvDataCollectorTimerRunning = false
        dispatchDataCollectorTimer.invalidate()
    }
    
    func startAdvDataCollector() {
        self.isAdvPackageSwitchOn = true
        startDataCollector()
    }
    
    fileprivate func getCalibrationData(_ advPackage: BLEDevice) -> CalibrationData! {
    
         let rssi = advPackage.rssiValue
         let txPower = Int(advPackage.advertisementPackage.cBAdvertisementDataTxPowerLevel)
         var data: CalibrationData!
         if rssi != nil && txPower != nil
         {
              data = CalibrationData(RSSI: rssi!, txPower: txPower, deviceName: advPackage.deviceName)
         } else if rssi != nil && txPower == nil
         {
              data = CalibrationData(RSSI: rssi!, txPower: nil, deviceName: advPackage.deviceName)
         } else
         {
            // invalid data
         }
        return data
    }

    fileprivate func startDataCollector() {
        guard !isAdvDataCollectorTimerRunning else {
            return
        }
        dispatchDataCollectorTimer = Timer.scheduledTimer(timeInterval: self.dataIntervalInSecond, target: self, selector: #selector(self.collectorSwitch), userInfo: nil, repeats: true)
        isAdvDataCollectorTimerRunning = true
    }
    
    @objc fileprivate func collectorSwitch()
    {   guard self.rawAdvPackage.count > 0 else { return }
        //stop receiving any adv package
        self.isAdvPackageSwitchOn = false
        // doing calculation
        for deviceID in self.rawAdvPackage.keys
        {
            if let values = self.rawAdvPackage[deviceID] , values.count > 0
            {
                let displayColor = values.first?.displayColor
                let averag = RSSIHelper.getAverageRSSI(values, shouldCalibrate: self.shouldCalibrateRSSI)
                let chartDataSetVM = RSSIChartDataSetViewModel(deviceID: deviceID, averageRSSI: averag, deviceName: (values.first?.deviceName)!, timeSlot: self.counter*interval, displayColor: displayColor!)
               RSSIAverage[deviceID] = chartDataSetVM
            }
        }
        //return the receiving state
        self.rssiChartModelDelegate?.didRSSIAverageValueGenerated(self.RSSIAverage, count: self.counter, needRefreshAll: false)
        counter += 1
        //release the gate to accept new adv
        self.rawAdvPackage.removeAll()
        self.RSSIAverage.removeAll()
        self.isAdvPackageSwitchOn = true
    }
    
    fileprivate func stopTimer() {
        isAdvDataCollectorTimerRunning = false
        dispatchDataCollectorTimer.invalidate()
    }
}
