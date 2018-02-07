//
//  CaliberationData.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 01/06/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
 class CalibrationData: ScanningPageViewModel {
    var txPower: Int!
    var rSSI: Int!
    var deviceName: String!
    init (RSSI: Int, txPower: Int! = 0, deviceName: String = "") {
        super.init()
        self.rSSI = RSSI
        self.txPower = txPower
        self.deviceName = deviceName
    }
}