//
//  EddyStoneAdvertisementSpec.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 11/02/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
import CoreBluetooth
enum EddystoneFrameTypeEnum: UInt8 {
    case UID = 0x00
    case URL = 0x10
    case TLM = 0x20
    case EID = 0x30
    case RESERVED = 0x40
    
    init?(value: UInt8) {
        switch value {
            case EddystoneFrameTypeEnum.UID.rawValue:
                self = EddystoneFrameTypeEnum.UID
            case EddystoneFrameTypeEnum.URL.rawValue:
                self = EddystoneFrameTypeEnum.URL
            case EddystoneFrameTypeEnum.TLM.rawValue:
                self = EddystoneFrameTypeEnum.TLM
            case EddystoneFrameTypeEnum.EID.rawValue:
                self = EddystoneFrameTypeEnum.EID
            case EddystoneFrameTypeEnum.RESERVED.rawValue:
                self = EddystoneFrameTypeEnum.RESERVED
            default:
                return nil
        }
    }
    
    func getValue() -> String {
        switch self {
            case .UID:
                return String(self.rawValue)
            case .URL:
                return String(self.rawValue)
            case .TLM:
                return String(self.rawValue)
            case .EID:
                return String(self.rawValue)
            default:
                return String(self.rawValue)
        }
    }
    
    func desciption() -> String {
        switch self {
            case .UID:
                return "UID"
            case .URL:
                return "URL"
            case .TLM:
                return "TLM"
            case .EID:
                return "EID"
            default:
                return "RESERVED"
        }
    }
    
    static func getEddystoneFrameType(value: UInt8) -> EddystoneFrameTypeEnum! {
        switch value {
            case EddystoneFrameTypeEnum.UID.rawValue:
                return EddystoneFrameTypeEnum.UID
            case EddystoneFrameTypeEnum.URL.rawValue:
                return EddystoneFrameTypeEnum.URL
            case EddystoneFrameTypeEnum.TLM.rawValue:
                return EddystoneFrameTypeEnum.TLM
            case EddystoneFrameTypeEnum.EID.rawValue:
                return EddystoneFrameTypeEnum.EID
            case EddystoneFrameTypeEnum.RESERVED.rawValue:
                return EddystoneFrameTypeEnum.RESERVED
            default:
                return nil
        }
    }
}

internal class EddystoneAdvertisementSpec: BeaconAdvertisementSpec {
    let eddyStoneIDFixed: CBUUID = CBUUID(string: "0xFEAA")
    //required 8 bits state for type of service. ref: https://github.com/google/eddystone/blob/master/protocol-specification.md
    var frameTypeSpec = SpecificationView(offset: 0, length: 1, dataLengthRange: 1..<2, description: "RESERVED", isMandatory: true)!

    var serviceDataRaw = ""
    var beaconName: String {
        get {
            return "Eddystone" + Symbols.TradeMark
        }
    }
    
    func isEddystoneBeacon() -> Bool {
        if self.eddyStoneIDFixed == eddyStoneIDFixed { return true }
        return false
    }
    
    //need to be overrided
    func description() -> String {
        return ""
    }
    
    func getCompanyInfo() -> String {
        return getBeaconTradeMark(eddyStoneIDFixed.uuidString)
    }
}
