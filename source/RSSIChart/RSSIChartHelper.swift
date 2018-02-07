//
//  RSSIChartHelper.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 31/05/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
class RSSIHelper {
    static func getAverageRSSI(_ data: [CalibrationData], shouldCalibrate: Bool = false) -> Int {
        var rssi: [Int] = []
        if shouldCalibrate
        {
            for item in data {
                if let result = calibratedRSSI(item) {
                    rssi.append(result)
                } else
                {
                    //invalid measurement
                }
            }
        } else
        {
            for item in data {
                if let value = item.rSSI
                {
                    rssi.append(value)
                } else
                {
                    // Invalid rssi
                }
            }
        }
        return getAverageRSSI(rssi)
    }
    
    fileprivate static func getAverageRSSI(_ data: [Int]) -> Int {
        var milliWatt: [Double] = []
        var dBm = 0
        for value in data
        {
            let result = ToMilliWatt(value)
            milliWatt.append(result)
        }
        if milliWatt.count > 0
        {
            let average = meanValue(milliWatt)
            dBm = TodBm(average)
        }
        return dBm
    }
    
    fileprivate static func calibratedRSSI(_ data: CalibrationData) -> Int! {
        
        guard data.rSSI != nil && data.txPower != nil
            else { return nil }
        
        return data.rSSI - data.txPower
    }

    fileprivate static func ToMilliWatt(_ RSSI: Int) -> Double {
        var milliwatt: Double!
        var tempRSSI = RSSI
        // invalid value will be considered as too far or power beyond the measurement
        if RSSI >= 0 || RSSI <= -100
        {
            tempRSSI = -100
        }
        let exponent: Double = Double(tempRSSI) / 10
        milliwatt = 10 ^ exponent
        return milliwatt
    }
    
    fileprivate static func meanValue(_ rssiMilliWatt: [Double]) -> Double {
        return rssiMilliWatt.reduce(0.0) { (x, y) -> Double in
            return x + y / Double(rssiMilliWatt.count)
        }
    }
    
    fileprivate static func TodBm(_ milliWatt: Double) -> Int {
        var resultStep1 = TodBm_1(milliWatt)
        let roundedResult = resultStep1.roundToPlaces(0)
        return Int(roundedResult)
    }
    
    fileprivate static func TodBm_1(_ milliWatt: Double) -> Double {
        return 10 * (logC(milliWatt, forBase: 10))
    }
    
    fileprivate static func logC(_ val: Double, forBase base: Double) -> Double {
        return log(val)/log(base)
    }
}
