//
//  ManufacturerData4_1Spec.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 18/03/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
open class ManufacturerData4_1Spec
{
//    var companyID: String = Symbols.NOT_AVAILABLE
//    let companyIDBytesLength: Int = 2
//    var manufactureData: String = ""
    var companyID: SpecificationView
    var manufactureSpecificData: SpecificationView
    var criterias = [SpecificationView]()
    
//    init(companyID: String, restManufactureData: String) {
//        self.companyID = companyID
//        self.manufactureData = restManufactureData
//    }
//
//    init(manufacturerDataRaw: Data) {
//        self.manufacturerDataRaw = Array(manufacturerDataRaw)
//    }
    
    
    init() {
        self.companyID = SpecificationView(offset: 0, length: 2, dataLengthRange: 2..<3, description: "Company ID", isMandatory: true, initialSubscription: { (self) -> DataCalibrationStatus in
            guard self.data.count == 2 else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
        })!
        criterias.append(self.companyID)
        self.manufactureSpecificData = SpecificationView(offset: 2, dataLengthRange: 0..<255, description: "Undefined manufacture specific data", isMandatory: false, initialSubscription: { (self) -> DataCalibrationStatus in
            guard self.dataLengthRange.contains(self.data.count) else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
        })
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
    
    fileprivate func requiredDataLength() -> Int {
        return 2
    }
    
    func copyToSpec(data: [UInt8]) -> Bool {
        var isCopySucceed = false
        guard data.count >= requiredDataLength() else { return false }
        if data.count > requiredDataLength() { criterias.append(self.manufactureSpecificData) }
        for item in criterias {
            switch item.offset {
                case self.companyID.offset:
                    let newData = Array(data[self.companyID.offset..<self.companyID.offset + self.companyID.length!])
                    self.companyID.updateData(data: newData)
                    continue
                case self.manufactureSpecificData.offset:
                    let newData = Array(data[self.manufactureSpecificData.offset..<data.count])
                    self.manufactureSpecificData.updateData(data: newData)
                    continue
                default:
                    break
            }
        }
        isCopySucceed = areCriteriasFullfilled()
        return isCopySucceed
    }
    
    
    func description() -> String {
        var stringView = Symbols.NOT_AVAILABLE
        guard areCriteriasFullfilled() == true else { return stringView }
        let company = getCompanyInfo()
        let companyInfo = "Company: " + company.CompanyName + "<" + company.HexaValue + ">" + Symbols.newRow
        var manufactData: [UInt8] = []
        for item in self.manufactureSpecificData.data {
            manufactData.append(item as! UInt8)
        }
        let manufactureData = "Specific data: " + DataConvertHelper.getData(manufactData)
        stringView = companyInfo + manufactureData
        return stringView
    }
    
    func getCompanyInfo() -> CompanyIDPersist {
        let companyPersist = CompanyIDPersist()
        guard self.companyID.dataStatus == .verifiedValid else {
            companyPersist.CompanyName = Symbols.NOT_AVAILABLE
            companyPersist.HexaValue = Symbols.NOT_AVAILABLE
            companyPersist.DecimalValue = Symbols.NOT_AVAILABLE
            return companyPersist
        }
        //big endian on iOS
        let data: [UInt8] = [self.companyID.data[1] as! UInt8, self.companyID.data[0] as! UInt8]
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
//    func toString() ->String
//    {
//        var specStringFormat = ""
//        getCompanyInfo()
//        guard let comInfo = self.companyInfo else {
//            specStringFormat = "CompanyID: " + "<" + companyID + ">" + " " + manufactureData
//            return specStringFormat
//        }
//        specStringFormat = "Company: " + comInfo.CompanyName + "<" + comInfo.HexaValue + ">" + " " + manufactureData
//        return specStringFormat
//    }
//
//    fileprivate func getCompanyInfo()
//    {
//        guard companyID != Symbols.NOT_AVAILABLE, let listOfCompanyID = PersistentObjectManager.instance.companyIDListPersist.companies else { return }
//        guard let result = listOfCompanyID.filter({ $0.HexaValue == companyID}).first else { return }
//        companyInfo = result
//    }
}
