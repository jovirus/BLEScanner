//
//  DataConvertHelper.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 04/08/15.
//  Copyright (c) 2015 Jiajun Qiu. All rights reserved.
//

import CoreBluetooth
import Foundation

internal class DataConvertHelper {
    
    fileprivate static let supportingHexChar: [Character] = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","a","b","c","d","e","f"]
    fileprivate static let prefix = "0x"
    static var logManager = LogManager.instance
    
    struct Property
    {
        let Read = "Read"
        let Write = "Write"
        let WriteWithoutResponse = "WriteWithoutResponse"
        let Notify = "Notify"
        let NotifyEncryptionRequired = "NotifyEncryptionRequired"
        let Indicate = "Indicate"
        let IndicateEncryptionRequired = "IndicateEncryptionRequired"
        let Broadcast = "Broadcast"
        let AuthenticatedSignedWrites = "AuthenticatedSignedWrites"
        let ExtendedProperties = "ExtendedProperties"
        
        func containsProperty(_ name: String, properties: [String]) -> Bool
        {
            var isIncluded = false;
            let value = name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if properties.contains(value)
            {
                isIncluded = true;
            }
            return isIncluded
        }
    }
    
    static let properties = Property()
    
    static func toData(_ data: String) -> Data? {
        var value = data.trimmingCharacters(in: CharacterSet.whitespaces)
        guard value != "" else { return nil }
        
        // for user experience allow single hex digits like "0", "1", "f"
        if value.count == 1 && supportingHexChar.contains(value.first!) {
            value = "0" + String(value.first!)
        }
        guard value.count % 2 == 0 else { return nil }
        let items = Array(value)
        var buffer: [UInt8] = []
        var index = 0
        while index < value.count {
            var byteString = ""
            guard isValidHexValue(items[index]) && isValidHexValue(items[index+1]) else { return nil }
            byteString += String(items[index])
            byteString += String(items[index+1])
            guard let convertedData = UInt8(byteString, radix: 16) else { return nil }
            buffer.append(convertedData)
            index += 2
        }
        guard buffer.count > 0 else { return nil }
        let nsData = Data(bytes: UnsafePointer<UInt8>(buffer), count: buffer.count)
        return nsData
    }
    
    static func isValidHexValue(_ char: Character) ->Bool
    {
        var isValid = false
        let validHexValue = self.supportingHexChar.filter{ (x) in x == char }
        if validHexValue.count == 1
        {
            isValid = true;
            return isValid;
        }
        else
        {
            return isValid;
        }
    }
    
    static func getNSNumber16bit(_ data: NSNumber) -> String
    {
        let hex: String = prefix
        let rawValue = data.uint16Value
        let temp = hex + String(format: "%04X", rawValue)
        return temp
    }
    
    static func getNSData(_ data: Data) -> String
    {
        var hex: String = prefix
        var array = [UInt8](repeating: 0, count: data.count )
        (data as NSData).getBytes(&array, length: data.count * MemoryLayout<UInt8>.size)
        for item in array {
            let temp = NSString(format:"%02X",item) as String
            hex+=temp;
        }
        return hex;
    }
    
    static func getData(_ bytes: [UInt8]) -> String {
        guard bytes.count > 0 else { return Symbols.NOT_AVAILABLE }
        var hex: String = prefix
        for item in bytes {
            hex += String.init(format: "%02X", item)
        }
        return hex
    }
    
    static func getUUID(_ data: Data) -> CBUUID
    {
        var hex: String = "";
        if is16BitsUUID(data)
        {
            hex = prefix
        }
        var array = [UInt8](repeating: 0, count: data.count )
        (data as NSData).getBytes(&array, length: data.count * MemoryLayout<UInt8>.size)
        for index in 0 ..< array.count
        {
            switch index
            {
                case 3:
                    let temp = NSString(format:"%02X-",array[index]) as String
                    hex+=temp;
                    break;
                case 5:
                    let temp = NSString(format:"%02X-",array[index]) as String
                    hex+=temp;
                    break;
                case 7:
                    let temp = NSString(format:"%02X-",array[index]) as String
                    hex+=temp;
                    break;
                case 9:
                    let temp = NSString(format:"%02X-",array[index]) as String
                    hex+=temp;
                    break;
                default:
                    let temp = NSString(format:"%02X",array[index]) as String
                    hex+=temp;
            }
        }
        return CBUUID(string: hex)
    }
    
    private static func isValidCBUUID(uuid: String) -> Data! {
        var isValid: Data!
        let value = uuid.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard value != "" else{
            return isValid
        }
        
        guard let result = toData(value) else {
            return isValid
        }
        guard result.count == 2 || result.count == 4 || result.count == 16 else {
            return isValid
        }
        isValid = result
        return isValid
    }
    
    static func tryGetCBUUID(uuid: String) -> CBUUID! {
        var result: CBUUID!
        guard let data = isValidCBUUID(uuid: uuid) else {
            return result
        }
        result = getUUID(data)
        return result
    }

//    static func getUUIDString(_ array: NSArray) -> String
//    {
//        var uuid = "";
//        for item in array
//        {
//            guard type(of: item) is CBUUID.Type else {
//                continue
//            }
//            let cbuuid = item as! CBUUID
//            if is16BitsUUID(cbuuid.data) {
//                uuid = prefix
//            }
//            uuid += cbuuid.uuidString + ";"
//        }
//        if uuid != "" {
//            uuid = uuid.substring(to: uuid.index(before: uuid.endIndex))
//        }
//        return uuid
//    }
    
    static func getUUID(_ array: NSArray) -> [GattUUID] {
        var listOfUUID: [GattUUID] = []
        for item in array
        {
            guard type(of: item) is CBUUID.Type else {
                continue
            }
            let cbuuid = item as! CBUUID
            let gattuuid = GattUUID(assignedNumber: cbuuid, gattName: GattServiceUUID.getServiceName(cbuuid))
            listOfUUID.append(gattuuid)
        }
        return listOfUUID
    }
    
    static func getNSDictionary(_ dictionary: NSDictionary) -> String {
        var keyValuePair = ""
        for (key, value) in dictionary {
            guard type(of: key) is CBUUID.Type else { continue }
            let uuid = key as! CBUUID
            let serviceData = value as? Data
            let keyResult = prefix + uuid.uuidString
            keyValuePair += Symbols.bracketLeft+(keyResult)+Symbols.bracketRight
            guard let data = serviceData else { return keyValuePair }
            keyValuePair += Symbols.comma
            keyValuePair += DataConvertHelper.getNSData(data)
            keyValuePair += Symbols.semicolon
        }
        return keyValuePair;
    }
    
    static func getServiceData(_ dictionary: NSDictionary) -> ServiceDataCore5_0Spec! {
        var serviceDataSpec: ServiceDataCore5_0Spec!
        for (key, value) in dictionary
        {
            guard type(of: key) is CBUUID.Type else { continue }
            let uuid = key as! CBUUID
            let serviceData = value as? Data
            serviceDataSpec = ServiceDataCore5_0Spec(uuid: uuid, data: serviceData)
        }
        return serviceDataSpec
    }
    
    static func getBool(_ data: Bool?) -> String {
        return data == nil ? "": String(stringInterpolationSegment: data)
    }
    
    static func getDescriptorValue(_ data: AnyObject?) -> String {
        var descriptorValue: String = ""
        if let result = data {
            if result.isKind(of: NSData.self) {
                descriptorValue = DataConvertHelper.getNSData(result as! Data)
            }
            else if result.isKind(of: NSNumber.self) {
                var outPrintResult = ""
                outPrintResult.append(String(result.uintValue))
                descriptorValue = outPrintResult
            }
            else if result.isKind(of: NSString.self) {
                descriptorValue = String(describing: result)
            }
            else {
                descriptorValue = Symbols.NOT_SUPPORTED
            }
        }
        return descriptorValue
    }
        
    static func getCharacteristicProperty(_ value: CBCharacteristicProperties) ->[String]
    {
        var property:[String] = []
        
        if (value.rawValue & CBCharacteristicProperties.read.rawValue) > 0
        {
           property.append(self.properties.Read)
        }
        if (value.rawValue & CBCharacteristicProperties.write.rawValue) > 0
        {
           property.append(self.properties.Write)
        }
        if (value.rawValue & CBCharacteristicProperties.writeWithoutResponse.rawValue) > 0
        {
            property.append(self.properties.WriteWithoutResponse)
        }
        if (value.rawValue & CBCharacteristicProperties.notify.rawValue) > 0
        {
            property.append(self.properties.Notify)
        }
        if (value.rawValue & CBCharacteristicProperties.notifyEncryptionRequired.rawValue) > 0
        {
            property.append(self.properties.NotifyEncryptionRequired)
        }
        if (value.rawValue & CBCharacteristicProperties.indicate.rawValue) > 0
        {
            property.append(self.properties.Indicate)
        }
        if (value.rawValue & CBCharacteristicProperties.indicateEncryptionRequired.rawValue) > 0
        {
            property.append(self.properties.IndicateEncryptionRequired)
        }
        if (value.rawValue & CBCharacteristicProperties.broadcast.rawValue) > 0
        {
            property.append(self.properties.Broadcast)
        }
        if (value.rawValue & CBCharacteristicProperties.authenticatedSignedWrites.rawValue) > 0
        {
            property.append(self.properties.AuthenticatedSignedWrites)
        }
        if (value.rawValue & CBCharacteristicProperties.extendedProperties.rawValue) > 0
        {
            property.append(self.properties.ExtendedProperties)
        }
        return property
    }
    
    fileprivate static func is16BitsUUID(_ data: Data) -> Bool
    {
        var array = [UInt8](repeating: 0, count: data.count )
        (data as NSData).getBytes(&array, length: data.count * MemoryLayout<UInt8>.size)
        
        var is16BitsUUID = false
        if array.count == 2
        {
            is16BitsUUID = true
        }
        return is16BitsUUID;
    }
}
