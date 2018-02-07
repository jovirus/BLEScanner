//
//  LogLevelEnum.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 13/04/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
/**
 These are all log levels in application
 */
internal enum LogType : Int {
    // system level ble manager. logic application layer or lower. action
    case debug       = 0
    // what we are going to do. presentation layer. action
    case verbose     = 1
    // what has been done. presentation client layer. static
    case info        = 5
    // Data convertion, data helper. Data layer persistent layer, application layer, static
    case application = 10
    // data checking, validation, not harmful. client or application layer. static
    case warning     = 15
    // system level error. application layer. all type. marked as [System]
    case error       = 20
}

extension LogType: CustomStringConvertible {
        public var description: String {
            var result = ""
            switch self {
            case .debug:
                result = "Debug"
            case .verbose:
                result = "Verbose"
            case .info:
                result = "Info"
            case .application:
                result = "Application"
            case .error:
                result = "Error"
            case .warning:
                result = "Warning"
            }
            return result
    }
}
