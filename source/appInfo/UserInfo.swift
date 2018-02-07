//
//  UserInfo.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 22/06/16.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import EVReflection

class UserInfo: EVObject {
    var name: String!
    var version: String!
    var buildNumber: String!
    var deviceModel: String!
    var systemName: String!
    var systemVersion: String!
    var isProximityMonitoringEnabled: Bool!
    var lastRun: Date!
    
    required init() {
        self.version = AppInfo.version
        self.buildNumber = AppInfo.build
        self.name = AppInfo.name
        switch  AppInfo.deviceModel{
            case .phone:
                self.deviceModel = DeviceModelEnum.phone.description()
            case .pad:
                self.deviceModel = DeviceModelEnum.pad.description()
            case .carPlay:
                self.deviceModel = DeviceModelEnum.carPlay.description()
            case .tv:
                self.deviceModel = DeviceModelEnum.tv.description()
            case .unspecified:
                self.deviceModel = DeviceModelEnum.unspecified.description()
        }
        self.systemName = AppInfo.systemName
        self.systemVersion = AppInfo.systemVersion
        self.isProximityMonitoringEnabled = AppInfo.isProximityMonitoringEnabled
        lastRun = Date()
    }
    
    fileprivate init(name: String, version: String, buildNumber: String, deviceModel: String, systemName: String, systemVersion: String, isProximityMonitoringEnabled: Bool, lastRun: Date) {
        self.name = name
        self.version = version
        self.buildNumber = buildNumber
        self.deviceModel = deviceModel
        self.systemName = systemName
        self.systemVersion = systemVersion
        self.isProximityMonitoringEnabled = isProximityMonitoringEnabled
        self.lastRun = lastRun
    }
    
    @discardableResult
    func saveUserDefaults() -> UserDefaults {
        let defaults = UserDefaults.standard
        defaults.set(self.name, forKey: "name")
        defaults.set(self.version, forKey: "version")
        defaults.set(self.buildNumber, forKey: "buildNumber")
        defaults.set(self.deviceModel, forKey: "deviceModel")
        defaults.set(self.systemName, forKey: "systemName")
        defaults.set(self.systemVersion, forKey: "systemVersion")
        defaults.set(self.isProximityMonitoringEnabled, forKey: "isProximityMonitoringEnabled")
        defaults.set(self.lastRun, forKey: "lastRun")
        defaults.synchronize()
        return defaults
    }
    
    class func getUserDefaults() -> UserInfo! {
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey: "name")
        let version = defaults.string(forKey: "version")
        let buildNumber = defaults.string(forKey: "buildNumber")
        let deviceModel = defaults.string(forKey: "deviceModel")
        let systemName = defaults.string(forKey: "systemName")
        let systemVersion = defaults.string(forKey: "systemVersion")
        let isProximityMonitoringEnabled = defaults.bool(forKey: "isProximityMonitoringEnabled")
        let lastRun = defaults.object(forKey: "lastRun") as? Date
        guard name != nil && version != nil && buildNumber != nil && deviceModel != nil && systemName != nil && systemVersion != nil && lastRun != nil else {
            return nil
        }
        return UserInfo(name: name!, version: version!, buildNumber: buildNumber!, deviceModel: deviceModel!, systemName: systemName!, systemVersion: systemVersion!, isProximityMonitoringEnabled: isProximityMonitoringEnabled, lastRun: lastRun!)
    }
    
    @available(*, deprecated: 1.8, message: "use getUserDefaults() instead")
    override func propertyConverters() -> [(key: String, decodeConverter: ((Any?) -> ()), encodeConverter: (() -> Any?))] {
        return [(
            "isProximityMonitoringEnabled",
                {self.isProximityMonitoringEnabled = $0 as! Bool },
                {return self.isProximityMonitoringEnabled }),
            ("name",
                {self.name = $0 as! String },
                {return self.name }),
            ("version",
                {self.version = $0 as! String },
                {return self.version }),
            ("buildNumber",
                {self.buildNumber = $0 as! String },
                {return self.buildNumber }),
            ("deviceModel",
                {self.deviceModel = $0 as! String },
                {return self.deviceModel }),
            ("systemName",
                {self.systemName = $0 as! String },
                {return self.systemName }),
            ("systemVersion",
                {self.systemVersion = $0 as! String },
                {return self.systemVersion }),
            ("lastRun",
                {self.lastRun = $0 as! Date },
                {return self.lastRun }),
            
        ]
    }
    
    static func isNewVersion(lastUse: UserInfo, newInfo: UserInfo) -> Bool {
        var isNewerVersion: Bool = false
        if lastUse.version != newInfo.version && lastUse.version < newInfo.version {
                isNewerVersion = true
            } else if lastUse.version == newInfo.version && lastUse.buildNumber < newInfo.buildNumber {
                isNewerVersion = true
            } else {
                isNewerVersion = false
            }
        return isNewerVersion
    }
}

class UserInfoList: EVObject {
    var listOfUserInfo: [UserInfo] = []
}
