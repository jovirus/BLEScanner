//
//  SecurityDFUFile.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 15/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import iOSDFULibrary
import EVReflection


struct SecurityDFUFile: DFUFileProtocol {
    var savedAt: Date?

    var firmwareURL: URL {
        didSet {
            setNameSize()
        }
    }
    var firmwareName: String?
    var firmwareSize: UInt64?
    var firmwareType: DFUFileKind = .DistributionPackage
    
    func prepareDFUFile() -> DFUFirmware? {
        let firmware = DFUFirmware(urlToZipFile: firmwareURL)
        return firmware
    }
    
    init(firmwareURL: URL) {
        self.firmwareURL = firmwareURL
        self.savedAt = Date()
        setNameSize()
    }
    
    init(firmwareURL: URL, createdAt: Date) {
        self.firmwareURL = firmwareURL
        self.savedAt = createdAt
        setNameSize()
    }
    
    fileprivate mutating func setNameSize() {
        self.firmwareName = LocalAccessManager.instance.getFullFileName(fileURL: (self.firmwareURL))
        self.firmwareSize = LocalAccessManager.instance.getFileSize(fileURL: (self.firmwareURL))
    }
    
    func isType() -> SecurityDFUFile {
        return self
    }
}
