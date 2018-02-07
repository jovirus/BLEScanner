//
//  AppInfo.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 22/06/16.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

class AppInfo {
    static let version: String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
    static let build: String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String)
    static let name: String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String)
    static let deviceModel: DeviceModelEnum = DeviceModelEnum.toDeviceModel(userInterface: UIDevice.current.userInterfaceIdiom)
    static let systemVersion: String = UIDevice.current.systemVersion
    static let systemName: String = UIDevice.current.systemName
    static let isProximityMonitoringEnabled: Bool = UIDevice.current.isProximityMonitoringEnabled
    static let mobileName: String = UIDevice.current.name

}
