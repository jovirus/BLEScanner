//
//  DFUViewModelBase.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 02/01/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import iOSDFULibrary
import EVReflection

class DFUViewModelBase: DFUMainViewModelBase {
    var firmwareName: String = ""
    var firmwareSizeView: String = ""
    var firmwareSize: UInt64?
    var firmwareKind: DFUFileKind?
    var savedAt: Date?
    let Not_Available = "N/A"
    private(set) var dfuFile: DFUFileProtocol!
    private(set) var firmware: DFUFirmware?
    
    func setFirmware<T: DFUFileProtocol>(file: T) {
        if file is SecurityDFUFile {
            self.firmwareKind = DFUFileKind.DistributionPackage
        } else if file is LegacyDFUFile {
            self.firmwareKind = DFUFileKind.Binary
        }
        self.firmware = file.prepareDFUFile()
        self.firmwareName = file.firmwareName != nil ? file.firmwareName! : Not_Available
        self.firmwareSizeView = file.firmwareSize != nil ? ByteCountFormatter.string(fromByteCount: Int64(file.firmwareSize!), countStyle: .file) : Not_Available
        self.firmwareSize = file.firmwareSize
//        if isFirmwareReady() {
//            self.status = .readyUpdate
//            self.dfuDetailViewModelDelegate?.statusChanged(status: self.status)
//        }
        self.dfuFile = file
        self.savedAt = file.savedAt
    }
}
