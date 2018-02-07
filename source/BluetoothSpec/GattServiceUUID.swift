//
//  GattServiceUUID.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 17/09/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import CoreBluetooth

class GattServiceUUID {
    static let AlertNotification: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1811"), gattName: "Alert Notification Service")
    static let AutomationIO: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1815"), gattName: "Automation IO")
    static let Battery: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x180F"), gattName: "Battery Service")
    static let BloodPressure: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1810"), gattName: "Blood Pressure")
    static let BodyComposition: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x181B"), gattName: "Body Composition")
    static let BondManagement: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x181E"), gattName: "Bond Management")
    static let ContinuousGlucoseMonitoring: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x181F"), gattName: "Continuous Glucose Monitoring")
    static let CurrentTimeService: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1805"), gattName: "Current Time Service")
    static let CyclingPower: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1818"), gattName: "CyclingPower")
    static let CyclingSpeedAndCadence: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1816"), gattName: "Cycling Speed and Cadence")
    static let DeviceInformation: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x180A"), gattName: "Device Information")
    static let EnvironmentalSensing: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x181A"), gattName: "Environmental Sensing")
    static let GenericAccess: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1800"), gattName: "Generic Access")
    static let GenericAttribute: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1801"), gattName: "Generic Attribute")
    static let Glucose: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1808"), gattName: "Glucose")
    static let HealthThermometer: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1809"), gattName: "Health Thermometer")
    static let HeartRate: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x180D"), gattName: "Heart Rate")
    static let HumanInterfaceDevice: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1812"), gattName: "Human Interface Device")
    static let ImmediateAlert: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1802"), gattName: "Immediate Alert")
    static let IndoorPositioning: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1821"), gattName: "Indoor Positioning")
    static let InternetProtocolSupport: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1820"), gattName: "Internet Protocol Support")
    static let LinkLoss: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1803"), gattName: "Link Loss")
    static let LocationAndNavigation: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1819"), gattName: "Location and Navigation")
    static let NextDstChange: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1807"), gattName: "Next DST Change Service")
    static let PhoneAlertStatus: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x180E"), gattName: "Phone Alert Status Service")
    static let PulseOximeter: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1822"), gattName: "Pulse Oximeter")
    static let ReferenceTimeUpdate: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1806"), gattName: "Reference Time Update Service")
    static let RunningSpeedAndCadence: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1814"), gattName: "Running Speed and Cadence")
    static let ScanParameters: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1813"), gattName: "Scan Parameters")
    static let TxPower: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x1804"), gattName: "Tx Power")
    static let UserData: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x181C"), gattName: "User Data")
    static let WeightScale: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x181D"), gattName: "Weight Scale")
    
    //MARK: -NORDIC UUIDS
    static let LegacyDeviceFirmwareUpdate: GattUUID = GattUUID(assignedNumber: CBUUID(string: "00001530-1212-EFDE-1523-785FEABCD123"), gattName: "Legacy DFU Service")
    static let SecureDeviceFirmwareUpdate: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0xFE59"), gattName: "Secure DFU Service")
    static let ExperimentalButtonlessDFUService: GattUUID = GattUUID(assignedNumber: CBUUID(string: "8E400001-F315-4F60-9FB8-838830DAEA50"), gattName: "Experimental Buttonless DFU Service")
    static let NordicUARTService: GattUUID = GattUUID(assignedNumber: CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"), gattName: "Nordic UART Service")
    static let BeaconConfig: GattUUID = GattUUID(assignedNumber: CBUUID(string: "955A1523-0FE2-F5AA-A094-84B8D4F3E8AD"), gattName: "Beacon Config")
    static let LEDButtonService: GattUUID = GattUUID(assignedNumber: CBUUID(string: "00001523-1212-EFDE-1523-785FEABCD123"), gattName: "LED Button Service")
    
    //MARK: -THINGY UUIDS
    static let ThingyConfigurationService : GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680100-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Configuration Service")
    static let ThingyWeatherStationService : GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680200-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Weather Station Service")
    static let ThingyUIService : GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680300-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy User Interface Service")
    static let ThingyThingeeMotionService : GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680400-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Weather Station Service")
    static let ThingyThingeeSoundService : GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680500-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Sound Service")

    //MARK: -APPLE NOTIFICATION
    static let AppleNotificationCenterService : GattUUID = GattUUID(assignedNumber: CBUUID(string: "7905F431-B5CE-4E99-A40F-4B1E122D00D0"), gattName: "Apple Notification Center Service")
    static let AppleMediaService : GattUUID = GattUUID(assignedNumber: CBUUID(string: "89D3502B-0F36-433A-8EF4-C502AD55F8DC"), gattName: "Apple Media Service")

    //MARK: -MICRO:BIT
    static let MicrobitAccelerometerService : GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95D0753-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Accelerometer Service")
    static let MicrobitMagnetometerService : GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95DF2D8-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Magnetometer Service")
    static let MicrobitButtonService : GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95D9882-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Button Service")
    static let MicrobitIOPinService : GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95D127B-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit IO Pin Service")
    static let MicrobitLEDService : GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95DD91D-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit LED Service")
    static let MicrobitEventService : GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95D93AF-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Event Service")
    static let MicrobitDFUControlService : GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95D93B0-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit DFU Control Service")
    static let MicrobitTemperatureService : GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95D6100-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Temperature Service")
    
    
    static let gattServiceUuids: [String: GattUUID] = [
        "0x1811": AlertNotification,
        "0x1815": AutomationIO,
        "0x180F": Battery,
        "0x1810": BloodPressure,
        "0x181B": BodyComposition,
        "0x181E": BondManagement,
        "0x181F": ContinuousGlucoseMonitoring,
        "0x1805": CurrentTimeService,
        "0x1818": CyclingPower,
        "0x1816": CyclingSpeedAndCadence,
        "0x180A": DeviceInformation,
        "0x181A": EnvironmentalSensing,
        "0x1800": GenericAccess,
        "0x1801": GenericAttribute,
        "0x1808": Glucose,
        "0x1809": HealthThermometer,
        "0x180D": HeartRate,
        "0x1812": HumanInterfaceDevice,
        "0x1802": ImmediateAlert,
        "0x1821": IndoorPositioning,
        "0x1820": InternetProtocolSupport,
        "0x1803": LinkLoss,
        "0x1819": LocationAndNavigation,
        "0x1807": NextDstChange,
        "0x180E": PhoneAlertStatus,
        "0x1822": PulseOximeter,
        "0x1806": ReferenceTimeUpdate,
        "0x1814": RunningSpeedAndCadence,
        "0x1813": ScanParameters,
        "0x1804": TxPower,
        "0x181C": UserData,
        "0x181D": WeightScale,
        "00001530-1212-EFDE-1523-785FEABCD123": LegacyDeviceFirmwareUpdate,
        "0xFE59": SecureDeviceFirmwareUpdate,
        "8E400001-F315-4F60-9FB8-838830DAEA50": ExperimentalButtonlessDFUService,
        "6E400001-B5A3-F393-E0A9-E50E24DCCA9E": NordicUARTService,
        "955A1523-0FE2-F5AA-A094-84B8D4F3E8AD": BeaconConfig,
        "00001523-1212-EFDE-1523-785FEABCD123": LEDButtonService,
        "EF680100-9B35-4933-9B10-52FFA9740042": ThingyConfigurationService,
        "EF680200-9B35-4933-9B10-52FFA9740042": ThingyWeatherStationService,
        "EF680300-9B35-4933-9B10-52FFA9740042": ThingyUIService,
        "EF680400-9B35-4933-9B10-52FFA9740042": ThingyThingeeMotionService,
        "EF680500-9B35-4933-9B10-52FFA9740042": ThingyThingeeSoundService,
        "7905F431-B5CE-4E99-A40F-4B1E122D00D0": AppleNotificationCenterService,
        "89D3502B-0F36-433A-8EF4-C502AD55F8DC": AppleMediaService,
        "E95D0753-251D-470A-A062-FA1922DFA9A8": MicrobitAccelerometerService,
        "E95DF2D8-251D-470A-A062-FA1922DFA9A8": MicrobitMagnetometerService,
        "E95D9882-251D-470A-A062-FA1922DFA9A8": MicrobitButtonService,
        "E95D127B-251D-470A-A062-FA1922DFA9A8": MicrobitIOPinService,
        "E95DD91D-251D-470A-A062-FA1922DFA9A8": MicrobitLEDService,
        "E95D93AF-251D-470A-A062-FA1922DFA9A8": MicrobitEventService,
        "E95D93B0-251D-470A-A062-FA1922DFA9A8": MicrobitDFUControlService,
        "E95D6100-251D-470A-A062-FA1922DFA9A8": MicrobitTemperatureService]
    
    static func getFormat(_  uuid: CBUUID) -> GattUUID {
        let result = self.gattServiceUuids.filter { (x) -> Bool in
            if x.value.AssignedNumber == uuid {
                return true
            }
            return false
            }.first
        
        if let defaul = result {
            return defaul.value
        } else {
            return GattUUID(assignedNumber: uuid, gattName: Symbols.NOT_AVAILABLE)
        }
    
    }
    
    static func getServiceName(_ uuid: CBUUID) ->String
    {
        var valueName = ""
        let result = self.gattServiceUuids.filter { (x) -> Bool in
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
        let result = self.gattServiceUuids.filter { (x) -> Bool in
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
    
    static func ambiguousSearch(keyWords: String) -> [GattUUID] {
        var result: [GattUUID] = []
        let input = keyWords.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard input != "" else { return result }
        let potentialServices1 = self.gattServiceUuids.filter { (x) -> Bool in
            x.key.containsIgnoringCase(input)
        }
        for (_, value) in potentialServices1 {
            result.append(value)
        }
        let potentialServices2 = self.gattServiceUuids.filter { (x) -> Bool in x.value.GattName.containsIgnoringCase(input)}
        for (_, value) in potentialServices2 {
            result.append(value)
        }
        return result
    }
}
