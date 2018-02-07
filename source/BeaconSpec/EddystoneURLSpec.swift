//
//  EddystoneURLSpec.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 12/02/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation

struct URLEndcoding{
    var decimalValue: Int
    var hexValue: UInt8
    var expansion: String
    init(decimal: Int, hexa: UInt8, header: String) {
        decimalValue = decimal
        hexValue = hexa
        expansion = header
    }
}

internal class EddystoneURLSpec: EddystoneAdvertisementSpec
{
    var txPowerSpec: SpecificationView
    var urlSchemeSpec: SpecificationView
    var encodedURLSpec: SpecificationView
    var criterias = [SpecificationView]()
    static let reserveForFuture1: ClosedRange<UInt8> = 0x0E...0x20
    static let reserveForFuture2: ClosedRange<UInt8> = 0x7F...0xFF
    
    override init() {
        self.txPowerSpec = SpecificationView(offset: 1, length: 1, dataLengthRange: 1..<2, description: "Calibrated Tx power at 0 m", isMandatory: true, initialSubscription: {(self) -> DataCalibrationStatus in
            guard self.data.count == 1, let _ = self.data[0] as? Int8 else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
        })!
        self.urlSchemeSpec = SpecificationView(offset: 2, length: 1, dataLengthRange: 1..<2, description: "Encoded Scheme Prefix", isMandatory: true, initialSubscription: {(self) -> DataCalibrationStatus in
            guard self.data.count == 1, let schemaConv = self.data[0] as? UInt8, EddystoneURLSpec.PredefinedURLScheme.contains(where: { $0.hexValue == schemaConv }) else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
        })!
        self.encodedURLSpec = SpecificationView(offset: 3, dataLengthRange: 1..<18, description: "Encoded URL", isMandatory: true, initialSubscription: {(self) -> DataCalibrationStatus in
            guard self.dataLengthRange.contains(self.data.count) else { return DataCalibrationStatus.verifiedInvalid }
            for item in self.data {
                guard let sdata = item as? UInt8 else { return DataCalibrationStatus.verifiedInvalid }
                guard !EddystoneURLSpec.reserveForFuture1.contains(sdata) && !EddystoneURLSpec.reserveForFuture2.contains(sdata) else { return DataCalibrationStatus.verifiedInvalid }
            }
            return DataCalibrationStatus.verifiedValid
        })
        super.init()
        self.frameTypeSpec.updateData(data: [EddystoneFrameTypeEnum.URL.rawValue], description: EddystoneFrameTypeEnum.URL.desciption(), validator: {(self) -> DataCalibrationStatus in
            guard SpecificationView.isEqual(type: UInt8.self, a: self.data, b: [EddystoneFrameTypeEnum.URL.rawValue]) else { return DataCalibrationStatus.verifiedInvalid }
            return DataCalibrationStatus.verifiedValid
        })
        criterias = [self.frameTypeSpec, self.txPowerSpec, self.urlSchemeSpec, self.encodedURLSpec]
    }
    
    static let PredefinedURLScheme =
        [URLEndcoding(decimal: 0, hexa: 0x00, header: "http://www."),
        URLEndcoding(decimal: 1, hexa: 0x01, header: "https://www."),
        URLEndcoding(decimal: 2, hexa: 0x02, header: "http://"),
        URLEndcoding(decimal: 3, hexa: 0x03, header: "https://")]
    
    static let PredefinedEncodedURL =
        [URLEndcoding(decimal: 0, hexa: 0x00, header: ".com/"),
        URLEndcoding(decimal: 1, hexa: 0x01, header: ".org/"),
        URLEndcoding(decimal: 2, hexa: 0x02, header: ".edu/"),
        URLEndcoding(decimal: 3, hexa: 0x03, header: ".net/"),
        URLEndcoding(decimal: 4, hexa: 0x04, header: ".info/"),
        URLEndcoding(decimal: 5, hexa: 0x05, header: ".biz/"),
        URLEndcoding(decimal: 6, hexa: 0x06, header: ".gov/"),
        URLEndcoding(decimal: 7, hexa: 0x07, header: ".com"),
        URLEndcoding(decimal: 8, hexa: 0x08, header: ".org"),
        URLEndcoding(decimal: 9, hexa: 0x03, header: ".edu"),
        URLEndcoding(decimal: 10, hexa: 0x0a, header: ".net"),
        URLEndcoding(decimal: 11, hexa: 0x0b, header: ".info"),
        URLEndcoding(decimal: 12, hexa: 0x0c, header: ".biz"),
        URLEndcoding(decimal: 13, hexa: 0x0d, header: ".gov")]
    
    func getURLScheme(value: UInt8) -> URLEndcoding! {
        guard let index = EddystoneURLSpec.PredefinedURLScheme.index(where: { $0.hexValue == value }) else { return nil }
        return EddystoneURLSpec.PredefinedURLScheme[index]
    }
    
    func getEncodedURL(value: UInt8) -> URLEndcoding! {
        guard let index = EddystoneURLSpec.PredefinedEncodedURL.index(where: { $0.hexValue == value }) else { return nil }
        return EddystoneURLSpec.PredefinedEncodedURL[index]
    }
    
    fileprivate func minimunDataLength() -> Int {
        //eddystoneUUID + frameType + txPowerSpec + URLScheme + EncodedURL
        //counts in bytes
       return 4
    }
    
    fileprivate func maximunDataLength() -> Int {
        return 20
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
        guard data.count >= minimunDataLength() && data.count <= maximunDataLength() else { return false }
        guard data[frameTypeSpec.offset] == EddystoneFrameTypeEnum.URL.rawValue else { return isCopySucceed }
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
            case self.urlSchemeSpec.offset:
                let newData = Array(data[self.urlSchemeSpec.offset..<self.urlSchemeSpec.offset + self.urlSchemeSpec.length!])
                self.urlSchemeSpec.updateData(data: newData)
                continue;
            case self.encodedURLSpec.offset:
                let newData = Array(data[self.encodedURLSpec.offset..<data.count])
                self.encodedURLSpec.updateData(data: newData)
                continue;
            default:
                break;
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
        guard let txpowerValue = self.txPowerSpec.data.first as? Int8 else { return stringView }
        let tx = "Tx Power Level: " + String(describing: txpowerValue) + Symbols.dBm + Symbols.newRow
        guard let sdata = self.urlSchemeSpec.data[0] as? UInt8, let schema = getURLScheme(value: sdata) else { return stringView }
        var url = ""
        for item in self.encodedURLSpec.data {
            guard let sdata = item as? UInt8 else { return stringView }
            if let encoded = self.getEncodedURL(value: sdata) { url += encoded.expansion }
            else { url += String(describing: UnicodeScalar(sdata)) }
        }
        stringView = uuid + framType + tx + schema.expansion + url
//        getCompanyInfo()
        return stringView
    }
}
