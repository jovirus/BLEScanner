//
//  UserPreferenceEnum.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 13/09/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation

protocol UserPreferenceNotificationDelegate {
    func didScannerTimeOutSettingChange(interval: TimeInterval)
}

struct UserPreference {
    static var instance = UserPreference()
    var userPreferenceNotificationDelegate = [UserPreferenceNotificationDelegate]()
    
    //MARK: Scanner: - The interval used to time out the sacnner. Default 30 seconds
    var scannerTimeOut: ScannerTimeOutEnum {
        get {
            return getScannerTimeOut()
        }
        set(newValue) {
                updateScannerTimeOut(newValue)
            }
        }
    
    //MARK: DFU: - Alternative name used when connecting bootloader. If enabled, the phone will connect to a specified bootloader, otherwise the phone will find first found bootloader. Default true
    var enableAlternativeName: Bool {
        get {
            return getSettingAlternativeName()
        }
        set(newValue) {
            updateAlternativeName(newValue)
        }
    }
    
    init() { }
    
    mutating func registerViewControllerNotification(viewController: UserPreferenceNotificationDelegate) {
        userPreferenceNotificationDelegate.append(viewController)
    }
}

extension UserPreference {
    
//    fileprivate mutating func setScannerTimeOut(value: ScannerTimeOutEnum) {
//        updateScannerTimeOut(newValue: value)
//    }
//
//    fileprivate mutating func setAlternativeName(value: Bool) {
//
//    }

}

extension UserPreference {
    private func updateScannerTimeOut (_ newValue: ScannerTimeOutEnum) {
        guard scannerTimeOut != newValue else { return }
        let defaults = UserDefaults.standard
        defaults.set(newValue.rawValue, forKey: UserPreferenceScannerTimeOutKey)
        defaults.synchronize()
        //        for vc in userPreferenceNotificationDelegate {
        //            vc.didScannerTimeOutSettingChange(interval: newValue.getTimeInterval())
        //        }
    }
    
    private func updateAlternativeName (_ newValue: Bool) {
        guard self.enableAlternativeName != newValue else { return }
        let defaults = UserDefaults.standard
        defaults.set(newValue, forKey: UserPreferenceAlternativeNameKey)
        defaults.synchronize()
    }
}

extension UserPreference {
    fileprivate func getScannerTimeOut() -> ScannerTimeOutEnum {
        let defaults = UserDefaults.standard
        return ScannerTimeOutEnum.getScannerTimeOutEnum(value: defaults.integer(forKey: UserPreferenceScannerTimeOutKey))
    }
    
    fileprivate func getSettingAlternativeName() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: UserPreferenceAlternativeNameKey)
    }
}
