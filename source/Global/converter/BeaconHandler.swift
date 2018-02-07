//
//  BLEDataPackageHandler.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 30/07/15.
//  Copyright (c) 2015 Jiajun Qiu. All rights reserved.
//

import Foundation

open class BeaconHandler {
  static func getCompanyID(_ manufacturerData: [UInt8]) -> CompanyIDPersist! {
        guard let listOfCompanyID = PersistentObjectManager.instance.companyIDListPersist.companies else { return nil }
        for item in listOfCompanyID {
            if item.HexaValue == DataConvertHelper.getData(manufacturerData) {
                return item
            } else { continue }
        }
        return nil
    }

 static func getiBeaconFormatData(_ manufacturerData: Data) -> iBeaconAdvertisementSpec! {
        let manufacturer = iBeaconAdvertisementSpec()
        let dataBytes: [UInt8] = Array(manufacturerData)
        guard manufacturer.copyToSpec(data: dataBytes) else { return nil }
        return manufacturer
    }
    
 fileprivate static func getUUIDFormat(_ hexString: String) -> String {
        var position = 0
        var uuid = ""
        var hexData = Array(hexString)
        //8-4-4-4-12
        if hexData.count == 32 {
            uuid += String(hexData[position..<(position + 8)]).lowercased()
            uuid += "-"
            position += 8
            
            uuid += String(hexData[position..<(position + 4)]).lowercased()
            uuid += "-"
            position += 4
            
            uuid += String(hexData[position..<(position + 4)]).lowercased()
            uuid += "-"
            position += 4
            
            uuid += String(hexData[position..<(position + 4)]).lowercased()
            uuid += "-"
            position += 4
            
            uuid += String(hexData[position..<(position + 12)]).lowercased()
            position += 12
        }
        return uuid
    }
    
    static func getEddyStoneBeaconFormatData(_ serviceData: ServiceDataCore5_0Spec) -> EddystoneAdvertisementSpec! {
        let spec = EddystoneAdvertisementSpec()
        guard serviceData.uuid == spec.eddyStoneIDFixed, let data = serviceData.data  else { return nil }
        let dataBytes: [UInt8] = Array(data)
        guard dataBytes.count > spec.frameTypeSpec.length! else { return nil }
        guard let type = EddystoneFrameTypeEnum(value: dataBytes[spec.frameTypeSpec.offset]) else { return nil }
        switch type {
            case .UID:
                let UIDspec = getEddystoneUIDSpec(data: dataBytes)
                return UIDspec
            case .URL:
                let URLspec = getEddystoneURLSpec(data: dataBytes)
                return URLspec
            case .TLM:
                let TLMspec = getEddystoneTLMSpec(data: dataBytes)
                return TLMspec
            case .EID:
                //NOT IMPLEMENTED
                return nil
            default:
                return nil
        }
    }
    
    fileprivate static func getEddystoneUIDSpec(data: [UInt8]) -> EddystoneUIDSpec! {
        let spec = EddystoneUIDSpec()
        guard spec.copyToSpec(data: data) else { return nil }
        return spec
    }
    
    fileprivate static func getEddystoneURLSpec(data: [UInt8]) -> EddystoneURLSpec! {
        let spec = EddystoneURLSpec()
        guard spec.copyToSpec(data: data) else { return nil }
        return spec
    }
    
    fileprivate static func getEddystoneTLMSpec(data: [UInt8]) -> EddystoneTLMSpec! {
        let spec = EddystoneTLMSpec()
        guard spec.copyToSpec(data: data) else { return nil }
        return spec
    }
}
