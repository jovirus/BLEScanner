//
//  RSSIChartDataSetViewModel.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 08/06/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
import UIKit

class RSSIChartDataSetViewModel: ScanningPageViewModel {
    var deviceID: String!
    var averageRSSI: Int!
    var timeSlot: Int!
    var deviceName: String = Symbols.NOT_AVAILABLE
    
    init(deviceID: String, averageRSSI: Int, deviceName: String, timeSlot: Int) {
        super.init()
        self.deviceID = deviceID
        self.averageRSSI = averageRSSI
        self.deviceName = deviceName
        self.timeSlot = timeSlot
    }
    
    init(deviceID: String, averageRSSI: Int, deviceName: String, timeSlot: Int, displayColor: UIColor) {
        super.init()
        self.deviceID = deviceID
        self.averageRSSI = averageRSSI
        self.deviceName = deviceName
        self.timeSlot = timeSlot
        self.displayColor = displayColor
    }
}