//
//  DeviceModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 27/04/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

public enum DeviceModelEnum: Int {
    case unspecified = 0
    // iPhone and iPod touch style UI
    case phone = 1
    // iPad style UI
    case pad = 2
    // Apple TV style UI
    case tv = 3
    // CarPlay style UI
    case carPlay = 4
    
    func description() -> String {
        switch self {
        case .unspecified:
            return "unspecified"
        case .phone:
            return "phone"
        case .pad:
            return "pad"
        case .tv:
            return "tv"
        case .carPlay:
            return "carPlay"
        }
    }
    
    static func toDeviceModel(userInterface: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom) -> DeviceModelEnum {
        switch userInterface {
        case .phone:
            return .phone
        case .pad:
            return .pad
        case .tv:
            return .tv
        case .carPlay:
            return .carPlay
        case .unspecified:
            return .unspecified
        }
    }
}
