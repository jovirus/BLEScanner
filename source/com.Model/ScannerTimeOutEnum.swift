//
//  ScannerTimeOutEnum.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 12/09/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation

enum ScannerTimeOutEnum: Int {
    case _30sec = 0
    case _2min = 1
    case _5min = 2
    case _30min = 3
    //The maximum value is set to 7 days
    case _never = 9
    
    func description() -> String {
        switch self {
            case ._30sec:
                return "30sec"
            case ._2min:
                return "2min"
            case ._5min:
                return "5min"
            case ._30min:
                return "30min"
            case ._never:
                return "Never"
        }
    }
    
    func getTimeInterval() -> TimeInterval {
        switch self {
            case ._30sec:
                return TimeInterval(30)
            case ._2min:
                return TimeInterval(120)
            case ._5min:
                return TimeInterval(300)
            case ._30min:
                return TimeInterval(1800)
            case ._never:
                return TimeInterval(604800)
        }
    }
    
    static func getScannerTimeOutEnum(value: String) -> ScannerTimeOutEnum {
        switch value {
            case "30sec":
                return ._30sec
            case "2min":
                return ._2min
            case "5min":
                return ._5min
            case "30min":
                return ._30min
            case "Never":
                return ._never
            default:
                return ._30sec
        }
    }
    
    static func getScannerTimeOutEnum(value: Int) -> ScannerTimeOutEnum {
        switch value {
            case 0:
                return ._30sec
            case 1:
                return ._2min
            case 2:
                return ._5min
            case 3:
                return ._30min
            case 9:
                return ._never
            default:
                return ._30sec
        }
    }
}
