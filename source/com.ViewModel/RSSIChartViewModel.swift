//
//  RSSIChartViewModel.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 26/05/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import UIKit

protocol RSSIChartViewModelDelegate {
    func didUpdateRSSIChartData(_ averageValue: Dictionary<String, [RSSIChartDataSetViewModel]>, timeSlot: [String])
}

protocol RSSIChartViewModelProtocol{
    init(maximunValueOnView: Int)
}

extension RSSIChartViewModel: RSSIChartModelDelegate {
    func didScanningActionChanged(_ isScanningOn: Bool) {
        self.isScanningOn = isScanningOn
    }
    
    func didRSSIAverageValueGenerated(_ RSSIAverage: Dictionary<String, RSSIChartDataSetViewModel>, count: Int, needRefreshAll: Bool) {
        guard !needRefreshAll else {
            refreshedViewModel()
            self.rssiChartViewModelDelegate.didUpdateRSSIChartData(averageValue, timeSlot: timeSlot)
            return
        }
        guard isScanningOn else { return }
        for (deviceID, var value) in RSSIAverage {
            //update existing devices and add new devices
            if let listOfRssi = self.averageValue[deviceID] , listOfRssi.count < maximunValueOnView  {
                //addDeviceColor(&value)
                averageValue[deviceID]?.append(value)
            } else if let listOfRssi = self.averageValue[deviceID] , listOfRssi.count >= maximunValueOnView {
                averageValue[deviceID]?.removeFirst()
                //addDeviceColor(&value)
                averageValue[deviceID]?.append(value)
            } else
            {
                if count == 1 {
                    //addDeviceColor(&value)
                    averageValue[deviceID] = [value]
                } else if count > 1 && count <= maximunValueOnView {
                    
                    // this means the device appears up at anytime
                    let values = fillProtectorWithNewValue(count, newValue: &value)
                    averageValue[deviceID] = values
                } else if count > maximunValueOnView
                {
                    //maximun adding protector should not exceed the allowed numbers on view.
                    let values = fillProtectorWithNewValue(maximunValueOnView, newValue: &value)
                    averageValue[deviceID] = values
                }
            }
        }
        maintainTimeSlot(count)
        addProtectorsInTail(count)
        guard isValidateDataModel() else { return }
        tryApplyFilter()
        self.rssiChartViewModelDelegate?.didUpdateRSSIChartData(averageValue, timeSlot: timeSlot)
    }
}

 class RSSIChartViewModel: ScanningPageViewModel, RSSIChartViewModelProtocol  {
    //set the default value 2sec
    var timeSlot: [String] = []
    //deviceid is the key and list of average rssi at specific timeslot
    var averageValue: Dictionary<String, [RSSIChartDataSetViewModel]> = Dictionary()
    var userDefinedTimeSlot: Int = 2
    var maximunValueOnView: Int = 20
    var minimumRSSI = -100
    var maximumRSSI = 0
    var rssiChartViewModelDelegate: RSSIChartViewModelDelegate!
    
    var rssiChartModel: RSSIChartModel!
    var isScanningOn: Bool = true
    
    var scanningDeviceModel = ScanningDevicePageModel.instance
    
    required init(maximunValueOnView: Int) {
        super.init()
        rssiChartModel = RSSIChartModel(timeSlotSec: userDefinedTimeSlot, isNormalizedRSSI: false)
        rssiChartModel.rssiChartModelDelegate = self
        self.maximunValueOnView = maximunValueOnView
    }
    
    convenience override init() {
        self.init(maximunValueOnView: 20)
    }
    
    fileprivate func tryApplyFilter() {
        if scanningDeviceModel.isOnFilterModel && self.scanningDeviceModel.getFilteredDevice().count == 0
        {
            self.averageValue.removeAll()
        } else if !scanningDeviceModel.isOnFilterModel {
            return
        } else if scanningDeviceModel.isOnFilterModel && scanningDeviceModel.getFilteredDevice().count != 0 {
            for id in self.averageValue.keys
            {
                if !self.scanningDeviceModel.getFilteredDevice().contains(id)
                {
                    self.averageValue.removeValue(forKey: id)
                }
            }
        }
    }
    
    fileprivate func fillProtectorWithNewValue(_ numbersOfProtectors: Int,newValue: inout RSSIChartDataSetViewModel) -> [RSSIChartDataSetViewModel] {
        var protector: [RSSIChartDataSetViewModel] = []
        var dataSetVM: RSSIChartDataSetViewModel!
        // adding protectors before point
        for i in 0..<numbersOfProtectors-1
        {
            dataSetVM = RSSIChartDataSetViewModel(deviceID: newValue.deviceID, averageRSSI: self.minimumRSSI, deviceName:newValue.deviceName, timeSlot: i*userDefinedTimeSlot, displayColor: newValue.displayColor)
            protector.append(dataSetVM)
        }
        protector.append(newValue)
        return protector
    }
    
    fileprivate func addProtectorsInTail(_ count: Int) {
        // maintaining not-updated devices according to the adv packages and add protectors after
        for (deviceID, values) in averageValue {
            if let latestValue = values.last {
                if latestValue.timeSlot != count*userDefinedTimeSlot {
                    // in this case the value is not updated
                    var dataSetVM: RSSIChartDataSetViewModel!
                    dataSetVM = RSSIChartDataSetViewModel(deviceID: latestValue.deviceID, averageRSSI: latestValue.averageRSSI, deviceName: latestValue.deviceName, timeSlot: count*userDefinedTimeSlot, displayColor: latestValue.displayColor)
                    if values.count < maximunValueOnView {
                            averageValue[deviceID]?.append(dataSetVM)
                    } else if values.count >= maximunValueOnView {
                        // actually it can only be equals to the maximun count
                        averageValue[deviceID]?.removeFirst()
                        averageValue[deviceID]?.append(dataSetVM)
                    }
                }
            }
        }
    }
    
    fileprivate func maintainTimeSlot(_ count: Int) {
        if timeSlot.count < maximunValueOnView
        {
            timeSlot.append(String(count * userDefinedTimeSlot))
        } else if timeSlot.count >= maximunValueOnView
        {
            timeSlot.removeFirst()
            timeSlot.append(String(count * userDefinedTimeSlot))
        }
    }
    
    fileprivate func isValidateDataModel() -> Bool {
        var isValidDataModel = false
        for (_, value) in averageValue
        {
            if let lastValue = value.last, let firstValue = value.first {
                if lastValue.timeSlot == Int(timeSlot.last!)! && firstValue.timeSlot == Int(timeSlot.first!)!{
                    isValidDataModel = true
                }
            }
        }
        return isValidDataModel
    }
    
    func refreshedViewModel() {
        //clear all caches
        averageValue.removeAll()
        timeSlot.removeAll()
    }
}
