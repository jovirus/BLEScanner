//
//  DFUStatusEnum.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 30/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation

internal enum DFUStatus: String {
    case WaitingFirmware = "Waiting firmware"
    case Start = "Start"
    case Ready = "Ready"
    case Update = "Update"
    case Pause = "Pause"
    case Abort = "Abort"
    case Complete = "Complete"
    case Connecting = "Connecting"
    case Disconnecting = "Disconnecting"
}
