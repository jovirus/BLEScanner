//
//  EddystoneURLSpec.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 12/02/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation

internal class EddystoneUIDSpec: EddystoneAdvertisementSpec
{
    var txPowerSpec: SpecificationView
    var nameSpaceSpec: SpecificationView
    var instanceSpec: SpecificationView
    lazy var reservedSpec1: SpecificationView = {
        return SpecificationView(offset: 18, length: 1, dataLengthRange: 1..<2, description: "Reserved for future use, must be 0x00", data: 0x00 as UInt8, isMandatory: false) {
            guard  SpecificationView.isEqual(type: UInt8.self, a: $0.data, b: [0x00 as UInt8]) else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
        }
        }()!
    lazy var reservedSpec2: SpecificationView = {
        return SpecificationView(offset: 19, length: 1, dataLengthRange: 1..<2, description: "Reserved for future use, must be 0x00", data: 0x00, isMandatory: false) {
            guard  SpecificationView.isEqual(type: UInt8.self, a: $0.data, b: [0x00 as UInt8]) else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
        }
    }()!
    var omitedRFU: Bool = true
    var criterias = [SpecificationView]()
    
    override init() {
        self.txPowerSpec = SpecificationView(offset: 1, length: 1, dataLengthRange: 1..<2, description: "Calibrated Tx power at 0 m", isMandatory: true, initialSubscription: {(self) -> DataCalibrationStatus in
            guard self.data.count == 1, let _ = self.data[0] as? Int8 else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
        })!
        self.nameSpaceSpec = SpecificationView(offset: 2, length: 10, dataLengthRange: 10..<11, description: "10-byte Namespace", isMandatory: true, initialSubscription: {(self) -> DataCalibrationStatus in
            guard self.data.count == 10 else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
        })!
        self.instanceSpec = SpecificationView(offset: 12, length: 6, dataLengthRange: 6..<7, description: "6-byte Instance", isMandatory: true, initialSubscription: {(self) -> DataCalibrationStatus in
            guard self.data.count == 6 else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
        })!
        super.init()
        self.frameTypeSpec.updateData(data: [EddystoneFrameTypeEnum.UID.rawValue], description: EddystoneFrameTypeEnum.UID.desciption(), validator: {(self) -> DataCalibrationStatus in
            guard SpecificationView.isEqual(type: UInt8.self, a: self.data, b: [EddystoneFrameTypeEnum.UID.rawValue]) else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
        })
            criterias = [self.frameTypeSpec, self.txPowerSpec, self.nameSpaceSpec, self.instanceSpec]
        }
    
    override func description() -> String {
        var stringView = Symbols.NOT_AVAILABLE
        guard areCriteriasFullfilled() == true else { return stringView }
        let framType = "Frame Type: " + String(describing: self.frameTypeSpec.description) + Symbols.newRow
        let uuid = "Eddystone: " + self.eddyStoneIDFixed.uuidString + Symbols.newRow
        guard let txpowerValue = self.txPowerSpec.data.first as? Int8 else { return stringView }
        let tx = "Tx Power Level: " + String(describing: txpowerValue) + Symbols.dBm + Symbols.newRow
        var nameSpaceValue = ""
        for item in self.nameSpaceSpec.data {
            nameSpaceValue += String.init(describing: item)
        }
        let nameSpace = "Name Space: " + nameSpaceValue + Symbols.newRow
        var instanceValue = ""
        for item in self.nameSpaceSpec.data {
            instanceValue += String.init(describing: item)
        }
        let instance = "Instance: " + instanceValue
        stringView = uuid + framType + tx + nameSpace + instance
//        getCompanyInfo()
        return stringView
    }
    
    func copyToSpec(data: [UInt8]) -> Bool {
        var isCopySucceed = false
        guard data.count == requiredDataLength() else { return false }
        guard data[frameTypeSpec.offset] == EddystoneFrameTypeEnum.UID.rawValue else { return isCopySucceed }
        for item in criterias {
                switch item.offset {
                    case self.frameTypeSpec.offset:
                            let newData = Array(data[self.frameTypeSpec.offset..<self.frameTypeSpec.offset + self.frameTypeSpec.length!])
                            self.frameTypeSpec.updateData(data: newData)
                            continue;
                    case self.txPowerSpec.offset:
                        let tx = Int8.init(bitPattern: data[self.txPowerSpec.offset..<self.txPowerSpec.offset + self.txPowerSpec.length!].first!)
                            let newData = [tx]
                            self.txPowerSpec.updateData(data: newData)
                            continue;
                    case self.nameSpaceSpec.offset:
                            let newData = Array(data[self.nameSpaceSpec.offset..<self.nameSpaceSpec.offset + self.nameSpaceSpec.length!])
                            self.nameSpaceSpec.updateData(data: newData)
                            continue;
                    case self.instanceSpec.offset:
                            let newData = Array(data[self.instanceSpec.offset..<self.instanceSpec.offset + self.instanceSpec.length!])
                            self.instanceSpec.updateData(data: newData)
                            continue;
                    case self.reservedSpec1.offset:
                            let newData = Array(data[self.reservedSpec1.offset..<self.reservedSpec1.offset + self.reservedSpec1.length!])
                            self.reservedSpec1.updateData(data: newData)
                            continue;
                    case self.reservedSpec2.offset:
                            let newData = Array(data[self.reservedSpec2.offset..<self.reservedSpec2.offset + self.reservedSpec2.length!])
                            self.reservedSpec1.updateData(data: newData)
                            continue;
                    default:
                        break;
            }
        }
        isCopySucceed = areCriteriasFullfilled()
        return isCopySucceed
    }
    
    fileprivate func requiredDataLength() -> Int {
        //eddystoneUUID + frameType + txPowerSpec + nameSpaceSpec + instanceSpec
        //counts in bytes
         return 18
    }
    
    fileprivate func areCriteriasFullfilled () -> Bool {
        var isFullfilled = true
        for specView in self.criterias {
            if specView.dataStatus == DataCalibrationStatus.unable_vertify { continue }
            else if specView.dataStatus == .will_verify { isFullfilled = false; break }
            else if specView.dataStatus == .verifiedInvalid { isFullfilled = false; break }
        }
        return isFullfilled
    }
}
