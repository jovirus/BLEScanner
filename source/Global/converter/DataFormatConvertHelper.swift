//
//  DataFormatConvertHelper.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 18/02/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation

open class DataFormatConvertHelper
{
    static func toUInt16(bytes:[UInt8]) -> UInt16 {
        //This is for big endian by default
        return UInt16(bytes[0]) << 8 + UInt16(bytes[1])
    }
    
    static func toUInt32(bytes:[UInt8]) -> UInt32 {
        var value: UInt32 = 0
        for byte in bytes {
            value = value << 8
            value = value | UInt32(byte)
        }
        return value
    }
    
    static func toUInt(bytes:[UInt8]) -> UInt {
        var value: UInt = 0
        for byte in bytes {
            value = value << 8
            value = value | UInt(byte)
        }
        return value
    }
    
    static func HexTo88_DataFormat(_ _2BytesHex: [UInt8]) -> Float!
    {
        var result: Float = 0.0
        guard _2BytesHex.count == 2 else { return nil }
        result = Float(UInt8(_2BytesHex[0])) + Float(_2BytesHex[1])/256
        return result
    }
    
    static func toByteArray(_ bytesString: String) throws -> [UInt8]
    {
        guard bytesString != "" else { throw DataCastingError.invalidInput(input: bytesString) }
        var original = Array(bytesString.drop0xPrefix)
        var bytes: [UInt8] = []
        guard original.count % 2 == 0 else { throw DataCastingError.invalidInput(input: bytesString) }
        var index = 0
        while index < original.count {
            guard let value = (String(original[index]) + String(original[index+1])).hexaToUInt8 else { throw DataCastingError.invalidInput(input: bytesString) }
            bytes.append(value)
            index += 2
        }
        return bytes
    }
    
    static func stringFromTimeInterval(_ interval:TimeInterval) -> String {
        let ti = NSInteger(interval)
        let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600) % 24
        let days = (ti / 86400)
        return String(NSString(format: "%d days + %d:%0.2d:%0.2d.%0.3d",days,hours,minutes,seconds,ms))
    }
}
