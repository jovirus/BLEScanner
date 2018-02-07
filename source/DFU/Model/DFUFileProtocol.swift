//
//  DFUFile.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 15/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import iOSDFULibrary

protocol DFUFileProtocol {
    var firmwareURL: URL { get set }
    var firmwareName: String? { get set }
    var firmwareSize: UInt64?{ get set }
    var savedAt: Date? { get set }
    func prepareDFUFile() -> DFUFirmware?
    func isType() -> Self
}
