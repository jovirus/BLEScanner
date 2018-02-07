//
//  BLEAdertisementPackageHandler.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 30/07/15.
//  Copyright (c) 2015 Jiajun Qiu. All rights reserved.
//
import CoreBluetooth
import Foundation

protocol IBLEAdvertisementPackageHandler
{
    static func readAdvertisementPackage(_ advertisementPackage: [String: Any]) -> AdvertisementPackageWrapper
}

class BLEAdvertisementPackageHandler : IBLEAdvertisementPackageHandler {
    
    static func readAdvertisementPackage(_ advertisementPackage: [String: Any]) -> AdvertisementPackageWrapper
    {
        let advPackage = AdvertisementPackageWrapper();
        for (key, value) in advertisementPackage {
            switch key
            {
            case CBAdvertisementDataLocalNameKey:
                let localName = value as! NSString;
                advPackage.cBAdvertisementDataLocalName = localName as String;
                continue;
            case CBAdvertisementDataManufacturerDataKey:
                let manufacturerData = value as! Data
                advPackage.cBAdvertisementDataManufacturerData = manufacturerData
                continue;
            case CBAdvertisementDataServiceUUIDsKey:
                let serviceUUIDs = value as! NSArray
                let uuids = DataConvertHelper.getUUID(serviceUUIDs)
                advPackage.cBAdvertisementDataServiceUUIDs = uuids
                continue;
            case CBAdvertisementDataServiceDataKey:
                let serviceData = value as! NSDictionary
                advPackage.cBAdvertisementDataServiceData = serviceData;
                continue;
            case CBAdvertisementDataIsConnectable:
                let result = value as! NSNumber
                advPackage.cBAdvertisementDataIsConnectable = isConnectable(result)
                continue;
            case CBAdvertisementDataTxPowerLevelKey:
                let txPowerLevel = value as! NSNumber
                advPackage.cBAdvertisementDataTxPowerLevel = txPowerLevel.stringValue
                continue;
            case CBAdvertisementDataSolicitedServiceUUIDsKey:
                let solicitedServiceUUIDs = value as! NSArray
                advPackage.cBAdvertisementDataSolicitedServiceUUIDs = DataConvertHelper.getUUID(solicitedServiceUUIDs)
                continue;
            case CBAdvertisementDataOverflowServiceUUIDsKey:
                let overflowServiceUUIDs = value as! NSArray
                let uuids = DataConvertHelper.getUUID(overflowServiceUUIDs)
                advPackage.cBAdvertisementDataOverflowServiceUUIDs = uuids
                continue;
            default:
                break;
            }
        }
        return advPackage;
    }
    
    static func isConnectable(_ data: NSNumber) -> Bool
    {
        if data == 1 {
            return true
        } else {
            return false
        }
    }
}
