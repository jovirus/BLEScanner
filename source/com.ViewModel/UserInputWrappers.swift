//
//  WrittenValueWrapper.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 21/10/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import CoreBluetooth
open class WrittenValueWrapper
{
    open var writtenValue: String?
    open var writeType: CBCharacteristicWriteType?
    
    init(writtenValue: String, writeType: CBCharacteristicWriteType) {
        self.writtenValue = writtenValue
        self.writeType = writeType
    }
    
    init(){}
    
    func isValid() -> Bool {
        var isValid = false
        if let userInput = self.writtenValue, let _ = self.writeType, let _ = DataConvertHelper.toData(userInput)
        {
            isValid = true
        }
        return isValid
    }
}

open class UserChoseLogLevelFilter {
    var logLevel: LogType
    init(logLevel: LogType)
    {
        self.logLevel = logLevel
    }
}
