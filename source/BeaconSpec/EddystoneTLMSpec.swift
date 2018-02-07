//
//  EddystoneTLM.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 12/02/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
internal class EddystoneTLMSpec: EddystoneAdvertisementSpec
{
//    var FrameType = EddystoneFrameTypeEnum.TLM
//    static let versionFixed = "0x00"
//    var Version = ""
//    var BatteryVoltage_2_Bytes = ""
//    var BeaconTemperature_2_Bytes = ""
//    var AdvertisingPDUCount_4_Bytes = ""
//    var TimeSincePowerOnOrReboot_4_Bytes = ""
    
    var tlmVersionSpec: SpecificationView
    var batterySpec: SpecificationView
    var beaconTemperatureSpec: SpecificationView
    var advertisingPDUSpec: SpecificationView
    var rebootSpec: SpecificationView
    var criterias = [SpecificationView]()

    override init() {
        self.tlmVersionSpec = SpecificationView(offset: 1, length: 1, dataLengthRange: 1..<2, description: "TLM version", data: [0x00 as UInt8], isMandatory: true){(self) -> DataCalibrationStatus in
            guard SpecificationView.isEqual(type: UInt8.self, a: self.data, b: [0x00 as UInt8]) else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
            }!
        self.batterySpec = SpecificationView(offset: 2, length: 2, dataLengthRange: 2..<3, description: "Battery voltage, 1 mV/bit", isMandatory: true){(self) -> DataCalibrationStatus in
            guard self.data.count == 2, !self.data.contains(where: { $0 as? UInt8 == nil ? true : false })  else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
            }!
        self.beaconTemperatureSpec = SpecificationView(offset: 4, length: 2, dataLengthRange: 2..<3, description: "Beacon temperature", isMandatory: true){(self) -> DataCalibrationStatus in
            guard self.data.count == 2 else { return DataCalibrationStatus.verifiedInvalid }
            guard let tdata = self.data as? [UInt8], let _ = DataFormatConvertHelper.HexTo88_DataFormat(tdata) else { return DataCalibrationStatus.verifiedInvalid  }
            return DataCalibrationStatus.verifiedValid
            }!
        self.advertisingPDUSpec = SpecificationView(offset: 6, length: 4, dataLengthRange: 4..<5, description: "Advertising PDU count", isMandatory: true){(self) -> DataCalibrationStatus in
            guard self.data.count == 4, !self.data.contains(where: { $0 as? UInt8 == nil ? true : false }) else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
            }!
        self.rebootSpec = SpecificationView(offset: 10, length: 4, dataLengthRange: 4..<5, description: "Time since power-on or reboot", isMandatory: true){(self) -> DataCalibrationStatus in
            guard self.data.count == 4, !self.data.contains(where: { $0 as? UInt8 == nil ? true : false }) else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
            }!
        super.init()
        self.frameTypeSpec.updateData(data: [EddystoneFrameTypeEnum.TLM.rawValue], description: EddystoneFrameTypeEnum.TLM.desciption(), validator: {(self) -> DataCalibrationStatus in
            guard SpecificationView.isEqual(type: UInt8.self, a: self.data, b: [EddystoneFrameTypeEnum.TLM.rawValue]) else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
        })
        criterias = [self.tlmVersionSpec, self.batterySpec, self.beaconTemperatureSpec, self.advertisingPDUSpec, self.rebootSpec]
    }
    
    fileprivate func requiredDataLength() -> Int {
        return 14
    }
    
    fileprivate func areCriteriasFullfilled () -> Bool {
        var isFullfilled = true
        for reqr in self.criterias {
            if reqr.dataStatus == DataCalibrationStatus.unable_vertify { continue }
            else if reqr.dataStatus == .will_verify { isFullfilled = false; break }
            else if reqr.dataStatus == .verifiedInvalid { isFullfilled = false; break }
        }
        return isFullfilled
    }
    
    func copyToSpec(data: [UInt8]) -> Bool {
        var isCopySucceed = false
        guard data.count == requiredDataLength() else { return false }
        guard data[frameTypeSpec.offset] == EddystoneFrameTypeEnum.TLM.rawValue else { return isCopySucceed }
        for item in criterias {
            switch item.offset {
            case self.frameTypeSpec.offset:
                let newData = Array(data[self.frameTypeSpec.offset..<self.frameTypeSpec.offset + self.frameTypeSpec.length!])
                self.frameTypeSpec.updateData(data: newData)
                continue
            case self.tlmVersionSpec.offset:
                let newData = Array(data[self.tlmVersionSpec.offset..<self.tlmVersionSpec.offset + self.tlmVersionSpec.length!])
                self.tlmVersionSpec.updateData(data: newData)
                continue
            case self.batterySpec.offset:
                let newData = Array(data[self.batterySpec.offset..<self.batterySpec.offset + self.batterySpec.length!])
                self.batterySpec.updateData(data: newData)
                continue
            case self.beaconTemperatureSpec.offset:
                let newData = Array(data[self.beaconTemperatureSpec.offset..<self.beaconTemperatureSpec.offset + self.beaconTemperatureSpec.length!])
                self.beaconTemperatureSpec.updateData(data: newData)
                continue
            case self.advertisingPDUSpec.offset:
                let newData = Array(data[self.advertisingPDUSpec.offset..<self.advertisingPDUSpec.offset + self.advertisingPDUSpec.length!])
                self.advertisingPDUSpec.updateData(data: newData)
                continue
            case self.rebootSpec.offset:
                let newData = Array(data[self.rebootSpec.offset..<self.rebootSpec.offset + self.rebootSpec.length!])
                self.rebootSpec.updateData(data: newData)
                continue
            default:
                break
            }
        }
        isCopySucceed = areCriteriasFullfilled()
        return isCopySucceed
    }
    
    override func description() -> String
    {
        var stringView = Symbols.NOT_AVAILABLE
        guard areCriteriasFullfilled() == true else { return stringView }
        let uuid = "Eddystone: " + self.eddyStoneIDFixed.uuidString + Symbols.newRow
        let framType = "Frame Type: " + String(describing: self.frameTypeSpec.description) + Symbols.newRow
        let version = "Version: " + String(describing: self.tlmVersionSpec.data.first!).hexaToDecimalString + Symbols.newRow
        let battery = DataFormatConvertHelper.toUInt16(bytes: self.batterySpec.data as! [UInt8])
        let batteryView = "Battery: " + String(describing: battery) + Symbols.MilliVolt + Symbols.newRow
        guard let tdata = self.beaconTemperatureSpec.data as? [UInt8], var temperature = DataFormatConvertHelper.HexTo88_DataFormat(tdata) else { return stringView }
        let tempView = "Beacon Temperature:" + String(describing: temperature.roundToPlaces(2)) + Symbols.Celsius + Symbols.newRow
        let advPDU = "Advertising PDU Count: " + String(describing: DataFormatConvertHelper.toUInt32(bytes: self.advertisingPDUSpec.data as! [UInt8])) + Symbols.newRow
        let timeInterval = Double(DataFormatConvertHelper.toUInt32(bytes: self.rebootSpec.data as! [UInt8]))
        let powerOnSince = "Powered On Since: " + DataFormatConvertHelper.stringFromTimeInterval(timeInterval * 0.1)
        stringView = uuid + framType + version + batteryView + tempView + advPDU + powerOnSince
//        _ = getCompanyInfo()
        return stringView
    }
}
