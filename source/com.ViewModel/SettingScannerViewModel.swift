//
//  SettingScannerViewModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 12/09/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation

class SettingScannerViewModel {
    
    fileprivate(set)var timeoutValue: ScannerTimeOutEnum = ._30sec
    
    init() {
        self.timeoutValue = UserPreference.instance.scannerTimeOut
    }
    
    func setTimeoutScanner(value: ScannerTimeOutEnum) {
        self.timeoutValue = value
        UserPreference.instance.scannerTimeOut = self.timeoutValue
    }
}
