//
//  GattDescriptorUUID.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 25/09/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import CoreBluetooth

class GattDescriptorUUID {
    static let CharacteristicExtendedProperties: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2900"), gattName: "Characteristic Extended Properties")
    static let CharacteristicUserDescription: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2901"), gattName: "Characteristic User Description")
    static let ClientCharacteristicConfiguration: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2902"), gattName: "Client Characteristic Configuration")
    static let ServerCharacteristicConfiguration: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2903"), gattName: "Server Characteristic Configuration")
    static let CharacteristicPresentationFormat: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2904"), gattName: "Characteristic Presentation Format")
    static let CharacteristicAggregateFormat: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2905"), gattName: "Characteristic Aggregate Format")
    static let ValidRange: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2906"), gattName: "Valid Range")
    static let ExternalReportReference: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2907"), gattName: "External Report Reference")
    static let ReportReference: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2908"), gattName: "Report Reference")
    static let NumberOfDigitals: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2909"), gattName: "Number of Digitals")
    static let ValueTriggerSetting: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x290A"), gattName: "Value Trigger Setting")
    static let EnvironmentalSensingConfiguration: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x290B"), gattName: "Environmental Sensing Configuration")
    static let EnvironmentalSensingMeasurement: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x290C"), gattName: "Environmental Sensing Measurement")
    static let EnvironmentalSensingTriggerSetting: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x290D"), gattName: "Environmental Sensing Trigger Setting")
    static let TimeTriggerSetting: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x290E"), gattName: "Time Trigger Setting")
    
    static let gattDescriptorUuid: [String: GattUUID] = [
        "0x2900": CharacteristicExtendedProperties,
        "0x2901": CharacteristicUserDescription,
        "0x2902": ClientCharacteristicConfiguration,
        "0x2903": ServerCharacteristicConfiguration,
        "0x2904": CharacteristicPresentationFormat,
        "0x2905": CharacteristicAggregateFormat,
        "0x2906": ValidRange,
        "0x2907": ExternalReportReference,
        "0x2908": ReportReference,
        "0x2909": NumberOfDigitals,
        "0x290A": ValueTriggerSetting,
        "0x290B": EnvironmentalSensingConfiguration,
        "0x290C": EnvironmentalSensingMeasurement,
        "0x290D": EnvironmentalSensingTriggerSetting,
        "0x290E": TimeTriggerSetting
    ]
    
    static func getDescriptorName(_ uuid: CBUUID) ->String
    {
        var valueName = ""
        let result = self.gattDescriptorUuid.filter { (x) -> Bool in
            if x.value.AssignedNumber == uuid {
                return true
            }
            return false
            }.first
        
        if let keyValuePair = result {
            valueName = keyValuePair.value.GattName
        }
        return valueName
    }
    
    static func getUUIDPrefix(uuid: CBUUID) -> String {
        var uuidPrefix = ""
        let result = self.gattDescriptorUuid.filter { (x) -> Bool in
            if x.value.AssignedNumber == uuid {
                return true
            }
            return false
            }.first
        
        if let keyValuePair = result {
            uuidPrefix = keyValuePair.key
        } else {
            uuidPrefix = uuid.uuidString
        }
        return uuidPrefix
    }
    
    // This method should be updated.
    static func isClientCharacteristicConfiguration(_ data: CBUUID) ->Bool
    {
        var isClientCharacteristicConfiguration = false
        if data == ClientCharacteristicConfiguration.AssignedNumber
        {
            isClientCharacteristicConfiguration = true
        }
        return isClientCharacteristicConfiguration;
    }
}
