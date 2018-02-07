//
//  iBeaconAdvertisementSpec.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 10/02/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
import CoreBluetooth

internal class iBeaconAdvertisementSpec: BeaconAdvertisementSpec
{
    //0x004C is specified by apple
    var companyID: SpecificationView
    var beaconType: SpecificationView
    var proximityUUID: SpecificationView
    var major: SpecificationView
    var minor: SpecificationView
    var messuredPower: SpecificationView
    var criterias = [SpecificationView]()
    
    override init() {
        self.companyID = SpecificationView(offset: 0, length: 2, dataLengthRange: 2..<3, description: "Company ID", isMandatory: true, initialSubscription: { (self) -> DataCalibrationStatus in
            guard self.data.count == 2 else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
        })!
        self.criterias.append(companyID)
        self.beaconType = SpecificationView(offset: 2, length: 2, dataLengthRange: 2..<3, description: "Beacon type must be set to 0x0215 for all proximity beacons", isMandatory: true, initialSubscription: { (self) -> DataCalibrationStatus in
            let beaconType: [UInt8] = [0x02, 0x15]
            guard self.data.count == 2, SpecificationView.isEqual(type: UInt8.self, a: self.data, b: beaconType) else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
        })!
        self.criterias.append(beaconType)
        self.proximityUUID = SpecificationView(offset: 4, dataLengthRange: 16..<17, description: "128bit-UUID. Must not be set to all 0s", isMandatory: true, initialSubscription: { (self) -> DataCalibrationStatus in
            guard self.dataLengthRange.contains(self.data.count), self.data.map({ (x) -> Bool in
                guard let data = x as? UInt8, data != UInt8.min else { return false }
                return true
            }).contains(true) else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
        })
        self.criterias.append(proximityUUID)
        self.major = SpecificationView(offset: 20, length: 2, dataLengthRange: 2..<3, description: "Major 0x0000 = unset", isMandatory: true, initialSubscription: { (self) -> DataCalibrationStatus in
            guard self.dataLengthRange.contains(self.data.count) else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
        })!
        self.criterias.append(major)
        self.minor = SpecificationView(offset: 22, length: 2, dataLengthRange: 2..<3, description: "Minor 0x0000 = unset", isMandatory: true, initialSubscription: { (self) -> DataCalibrationStatus in
            guard self.dataLengthRange.contains(self.data.count) else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
        })!
        self.criterias.append(minor)
        self.messuredPower = SpecificationView(offset: 24, length: 2, dataLengthRange: 2..<3, description: "Minor 0x0000 = unset", isMandatory: true, initialSubscription: { (self) -> DataCalibrationStatus in
            guard self.dataLengthRange.contains(self.data.count) else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
        })!
        self.criterias.append(messuredPower)
    }
    
    fileprivate func requiredDataLength() -> Int {
        return 21
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
        guard data.count == requiredDataLength()  else { return false }
        for item in criterias {
            switch item.offset {
            case self.companyID.offset:
                let newData = Array(data[self.companyID.offset..<self.companyID.offset + self.companyID.length!])
                self.companyID.updateData(data: newData)
                continue
            case self.beaconType.offset:
                let newData = Array(data[self.beaconType.offset..<self.beaconType.offset + self.beaconType.length!])
                self.beaconType.updateData(data: newData)
                continue
            case self.proximityUUID.offset:
                let newData = Array(data[self.proximityUUID.offset..<self.proximityUUID.offset + self.proximityUUID.length!])
                self.proximityUUID.updateData(data: [CBUUID.init(data: Data(bytes: newData))])
                continue
            case self.major.offset:
                let newData = Array(data[self.major.offset..<self.major.offset + self.major.length!])
                self.major.updateData(data: newData)
                continue
            case self.minor.offset:
                let newData = Array(data[self.minor.offset..<self.minor.offset + self.minor.length!])
                self.minor.updateData(data: newData)
                continue
            case self.messuredPower.offset:
                let tx = Int8.init(bitPattern: data[self.messuredPower.offset..<self.messuredPower.offset + self.messuredPower.length!].first!)
                self.messuredPower.updateData(data: [tx])
                continue
            default:
                break
            }
        }
        isCopySucceed = areCriteriasFullfilled()
        return isCopySucceed
    }
    
    //    func toString() ->String
    //    {
    //        let specStringFormat = "Company: " + companyName + "<" + companyID + ">" + "\nBeacon Type: " + beaconType + "\nData Length: " + beaconType_dataLength + "\nUUID: " + proximityUUID + "\nMajor: " + major + "\nMinor: " + minor + "\nRSSI: " + measuredPower + "dBm";
    //        return specStringFormat
    //    }
    
    func description() -> String {
        guard areCriteriasFullfilled() == true else { return Symbols.NOT_AVAILABLE }
        let company = getCompanyInfo()
        let companyInfo = "Company name: " + company.CompanyName + "<id: " + company.HexaValue + ">" + Symbols.newRow
        let type = "Beacon Type: " + String(self.beaconType.data[0] as! UInt8) + Symbols.newRow
        let dataLength = "Data Length: " + String(self.beaconType.data[1] as! UInt8) + Symbols.newRow
        let proximityUUID = "UUID: " + (self.proximityUUID.data.first as! CBUUID).uuidString + Symbols.newRow
        let major = "Major: " + String(DataFormatConvertHelper.toUInt16(bytes: [self.major.data[0] as! UInt8, self.major.data[1] as! UInt8])) + Symbols.newRow
        let minor = "Minor: " + String(DataFormatConvertHelper.toUInt16(bytes: [self.minor.data[0] as! UInt8, self.minor.data[1] as! UInt8])) + Symbols.newRow
        let rssi = "TX: " + String(self.messuredPower.data.first as! Int8)
        return companyInfo + type + dataLength + proximityUUID + major + minor + rssi
    }
    
    //The data length has to be 0x15 and 0x02
//    var beaconType_dataLength: String = "0x15"
//    var beaconType: String = "0x02"
//
//    var proximityUUID: String = ""
//    var major: String = ""
//    var minor: String = ""
//    var measuredPower: String = ""
//    var manufactureRaw: String = ""
//    var companyName: String = ""
//    var beaconName: String {
//        get {
//            return "nRF Beacon"
//        }
//    }
    
    func getCompanyInfo() -> CompanyIDPersist {
        let companyPersist = CompanyIDPersist()
        guard self.companyID.dataStatus == .verifiedValid else {
            companyPersist.CompanyName = Symbols.NOT_AVAILABLE
            companyPersist.HexaValue = Symbols.NOT_AVAILABLE
            companyPersist.DecimalValue = Symbols.NOT_AVAILABLE
            return companyPersist
        }
        var data = [UInt8]()
        for item in self.companyID.data {
            let value = item as! UInt8
            data.append(value)
        }
        if let result = BeaconHandler.getCompanyID(data) {
            return result
        } else {
            companyPersist.CompanyName = ""
            let decimal = DataFormatConvertHelper.toUInt16(bytes: data)
            companyPersist.DecimalValue = String(decimal)
            let nsNumber = NSNumber(value: decimal)
            companyPersist.HexaValue = DataConvertHelper.getNSNumber16bit(nsNumber)
            return companyPersist
        }
    }
}
