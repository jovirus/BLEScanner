//
//  BLEDeviceManagerDelegate.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 28/07/15.
//  Copyright (c) 2015 Jiajun Qiu. All rights reserved.
//

import Foundation

Protocol BLEDeviceManagerDelegate{
        func didListOfBLEDevicesUpdate(newDevice: BLEDevice)
}
