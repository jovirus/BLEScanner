//
//  LegacyDFUFile.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 15/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import iOSDFULibrary

struct LegacyDFUFile: DFUFileProtocol{
    var savedAt: Date?
    var firmwareName: String?
    var firmwareSize: UInt64?
    var firmwareType: DFUFirmwareType!
    var firmwareURL: URL {
        didSet {
            setFirmwareNameSize()
        }
    }
    var firmwareDatURL: URL? {
        didSet {
            setDatNameSize()
        }
    }
    var firmwareDatName: String?

    init(firmwareURL: URL) {
        self.firmwareURL = firmwareURL
        defer {
            self.firmwareURL = firmwareURL
        }
        self.savedAt = Date()
    }
    
    init(firmwareURL: URL, datFile: URL?, firmwareType: DFUFirmwareType, createdAt: Date) {
        self.firmwareURL = firmwareURL
        self.firmwareDatURL = datFile
        self.firmwareType = firmwareType
        self.savedAt = createdAt
        defer {
            self.firmwareURL = firmwareURL
            self.firmwareDatURL = firmwareDatURL
        }
    }
    
    fileprivate mutating func setFirmwareNameSize() {
        let name = LocalAccessManager.instance.getFullFileName(fileURL: (self.firmwareURL))
        let size = LocalAccessManager.instance.getFileSize(fileURL: (self.firmwareURL))
        self.firmwareName = name != nil ? name : ""
        self.firmwareSize = size != nil ? size : 0
    }
    
    fileprivate mutating func setDatNameSize() {
        guard self.firmwareDatURL != nil else {
            return
        }
        let nameDat = LocalAccessManager.instance.getFullFileName(fileURL: (self.firmwareDatURL)!)
        firmwareDatName = nameDat != nil ? nameDat : ""
    }
    
    func prepareDFUFile() -> DFUFirmware? {
        var firmware: DFUFirmware!
        do {
            _ = try Data.init(contentsOf: firmwareURL)
        }
        catch let err as NSError {
            print(err)
        }
        firmware = DFUFirmware(urlToBinOrHexFile: firmwareURL, urlToDatFile: firmwareDatURL, type: firmwareType)
        return firmware
    }
    
    func isType() -> LegacyDFUFile {
        return self
    }
}
