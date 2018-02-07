//
//  settingScannerTimeOutPickerViewModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 12/09/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation

protocol SettingScannerTimeOutDelegate {
    func didTimeOutChoose(time: ScannerTimeOutEnum)
}

class SettingScannerTimeOutPickerViewModel {
    private(set)var timeoutOptions: [ScannerTimeOutEnum] = [ScannerTimeOutEnum._30sec,
                                                ScannerTimeOutEnum._2min,
                                                ScannerTimeOutEnum._5min,
                                                ScannerTimeOutEnum._30min,
                                                ScannerTimeOutEnum._never]
    
    var settingScannerTimeOutDelegate: SettingScannerTimeOutDelegate?
    private(set)var pickedTimeOut: ScannerTimeOutEnum!
    
    func setTimeOut(value: ScannerTimeOutEnum) {
        self.pickedTimeOut = value
    }
    
    func notifyChange() {
        self.settingScannerTimeOutDelegate?.didTimeOutChoose(time: pickedTimeOut)
    }
}
