//
//  GattCharacteristicsUUID.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 22/09/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import CoreBluetooth

class GattCharacteristicsUUID {
    static let AerobicHeartRateLowerLimit: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A7E"), gattName: "Aerobic Heart Rate Lower Limit")
    static let AerobicHeartRateUpperLimit: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A84"), gattName: "Aerobic Heart Rate Upper Limit")
    static let AerobicThreshold: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A7F"), gattName: "Aerobic Threshold")
    static let Age: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A80"), gattName: "Age")
    static let Aggregate: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A5A"), gattName: "Aggregate")
    static let AlertCategoryID: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A43"), gattName: "Alert Category ID")
    static let AlertCategoryIDBitMask: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A42"), gattName: "Alert Category ID Bit Mask")
    static let AlertLevel: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A06"), gattName: "Alert Level")
    static let AlertNotificationControlPoint: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A44"), gattName: "AlertNotificationControlPoint")
    static let AlertStatus: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A3F"), gattName: "AlertStatus")
    static let Altitude: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AB3"), gattName: "Altitude")
    static let AnaerobicHeartRateLowerLimit: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A81"), gattName: "Anaerobic Heart Rate Lower Limit")
    static let AnaerobicHeartRateUpperLimit: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A82"), gattName: "Anaerobic Heart Rate Upper Limit")
    static let AnaerobicThreshold: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A83"), gattName: "Anaerobic Threshold")
    static let Analog: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A58"), gattName: "Analog")
    static let ApparentWindDirection : GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A73"), gattName: "Apparent Wind Direction ")
    static let ApparentWindSpeed: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A72"), gattName: "Apparent Wind Speed")
    static let Appearance: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A01"), gattName: "Appearance")
    static let BarometricPressureTrend: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AA3"), gattName: "Barometric Pressure Trend")
    static let BatteryLevel: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A19"), gattName: "Battery Level")
    static let BloodPressureFeature: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A49"), gattName: "Blood Pressure Feature")
    static let BloodPressureMeasurement	: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A35"), gattName: "Blood Pressure Measurement")
    static let BodyCompositionFeature: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A9B"), gattName: "Body Composition Feature")
    static let BodyCompositionMeasurement: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A9C"), gattName: "Body Composition Measurement")
    static let BodySensorLocation: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A38"), gattName: "Body Sensor Location")
    static let BondManagementControlPoint: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AA4"), gattName: "Bond Management Control Point")
    static let BondManagementFeature: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AA5"), gattName: "Bond Management Feature")
    static let BootKeyboardInputReport: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A22"), gattName: "Boot Keyboard Input Report")
    static let BootKeyboardOutputReport: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A32"), gattName: "Boot Keyboard Output Report")
    static let BootMouseInputReport: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A33"), gattName: "Boot Mouse Input Report")
    static let CentralAddressResolution: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AA6"), gattName: "Central Address Resolution")
    static let CGMFeature: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AA8"), gattName: "CGM Feature")
    static let CGMMeasurement: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AA7"), gattName: "CGM Measurement")
    static let CGMSessionRunTime: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AAB"), gattName: "CGM Session Run Time")
    static let CGMSessionStartTime: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AAA"), gattName: "CGM Session Start Time")
    static let CGMSpecificOpsControlPoint: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AAC"), gattName: "CGM Specific Ops Control Point")
    static let CGMStatus: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AA9"), gattName: "CGM Status")
    static let CSCFeature: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A5C"), gattName: "CSC Feature")
    static let CSCMeasurement: GattUUID = GattUUID(assignedNumber:  CBUUID(string: "0x2A5B"), gattName: "CSC Measurement")
    static let CurrentTime: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A2B"), gattName: "Current Time")
    static let CyclingPowerControlPoint: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A66"), gattName: "Cycling Power Control Point")
    static let CyclingPowerFeature: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A65"), gattName: "Cycling Power Feature")
    static let CyclingPowerMeasurement: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A63"), gattName: "Cycling Power Measurement")
    static let CyclingPowerVector: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A64"), gattName: "Cycling Power Vector")
    static let DatabaseChangeIncrement: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A99"), gattName: "Database Change Increment")
    static let DateOfBirth: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A85"), gattName: "Date of Birth")
    static let DateOfThresholdAssessment: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A86"), gattName: "Date of Threshold Assessment")
    static let DateTime: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A08"), gattName: "Date Time")
    static let DayDateTime: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A0A"), gattName: "Day Date Time")
    static let DayOfWeek: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A09"), gattName: "Day of Week")
    static let DescriptorValueChanged: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A7D"), gattName: "Descriptor Value Changed")
    static let DeviceName: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A00"), gattName: "Device Name")
    static let DewPoint: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A7B"), gattName: "Dew Point")
    static let Digital: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A56"), gattName: "Digital")
    static let DSTOffset: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A0D"), gattName: "DST Offset")
    static let Elevation: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A6C"), gattName: "Elevation")
    static let EmailAddress: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A87"), gattName: "Email Address")
    static let ExactTime256: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A0C"), gattName: "Exact Time 256")
    static let FatBurnHeartRateLowerLimit: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A88"), gattName: "Fat Burn Heart Rate Lower Limit")
    static let FatBurnHeartRateUpperLimit: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A89"), gattName: "Fat Burn Heart Rate Upper Limit")
    static let FirmwareRevisionString: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A26"), gattName: "Firmware Revision String")
    static let FirstName: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A8A"), gattName: "First Name")
    static let FiveZoneHeartRateLimits: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A8B"), gattName: "Five Zone Heart Rate Limits")
    static let FloorNumber: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AB2"), gattName: "Floor Number")
    static let Gender: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A8C"), gattName: "Gender")
    static let GlucoseFeature: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A51"), gattName: "Glucose Feature")
    static let GlucoseMeasurement: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A18"), gattName: "Glucose Measurement")
    static let GlucoseMeasurementContext: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A34"), gattName: "Glucose Measurement Context")
    static let GustFactor: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A74"), gattName: "Gust Factor")
    static let HardwareRevisionString: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A27"), gattName: "Hardware Revision String")
    static let HeartRateControlPoint: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A39"), gattName: "Heart Rate Control Point")
    static let HeartRateMax: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A8D"), gattName: "Heart Rate Max")
    static let HeartRateMeasurement: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A37"), gattName: "Heart Rate Measurement")
    static let HeatIndex: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A7A"), gattName: "Heat Index")
    static let Height: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A8E"), gattName: "Height")
    static let HIDControlPoint: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A4C"), gattName: "HID Control Point")
    static let HIDInformation: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A4A"), gattName: "HID Information")
    static let HipCircumference: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A8F"), gattName: "Hip Circumference")
    static let Humidity: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A6F"), gattName: "Humidity")
    static let IEEE11073_20601RegulatoryCertificationDataList: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A2A"), gattName: "IEEE 11073-20601 Regulatory Certification Data List")
    static let IndoorPositioningConfiguration: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AAD"), gattName: "Indoor Positioning Configuration")
    static let IntermediateCuffPressure: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A36"), gattName: "Intermediate Cuff Pressure")
    static let IntermediateTemperature: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A1E"), gattName: "Intermediate Temperature")
    static let Irradiance: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A77"), gattName: "Irradiance")
    static let Language: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AA2"), gattName: "Language")
    static let LastName: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A90"), gattName: "Last Name")
    static let Latitude: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AAE"), gattName: "Latitude")
    static let LNControlPoint: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A6B"), gattName: "LN Control Point")
    static let LNFeature: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A6A"), gattName: "LN Feature")
    static let LocalEastCoordinate: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AB1"), gattName: "Local East Coordinate")
    static let LocalNorthCoordinate: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AB0"), gattName: "Local North Coordinate")
    static let LocalTimeInformation: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A0F"), gattName: "Local Time Information")
    static let LocationAndSpeed: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A67"), gattName: "Location and Speed")
    static let LocationName: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AB5"), gattName: "Location Name")
    static let Longitude: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AAF"), gattName: "Longitude")
    static let MagneticDeclination: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A2C"), gattName: "Magnetic Declination")
    static let MagneticFluxDensity_2D: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AA0"), gattName: "Magnetic Flux Density - 2D")
    static let MagneticFluxDensity_3D: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AA1"), gattName: "Magnetic Flux Density - 3D")
    static let ManufacturerNameString: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A29"), gattName: "Manufacturer Name String")
    static let MaximumRecommendedHeartRate: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A91"), gattName: "Maximum Recommended Heart Rate")
    static let MeasurementInterval: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A21"), gattName: "Measurement Interval")
    static let ModelNumberString: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A24"), gattName: "Model Number String")
    static let Navigation: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A68"), gattName: "Navigation")
    static let NewAlert: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A46"), gattName: "New Alert")
    static let PeripheralPreferredConnectionParameters: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A04"), gattName: "Peripheral Preferred Connection Parameters")
    static let PeripheralPrivacyFlag: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A02"), gattName: "Peripheral Privacy Flag")
    static let PLXContinuousMeasurement: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A5F"), gattName: "PLX Continuous Measurement")
    static let PLXFeatures: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A60"), gattName: "PLX Features")
    static let PLXSpotCheckMeasurement: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A5E"), gattName: "PLX Spot-Check Measurement")
    static let PnPID: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A50"), gattName: "PnP ID")
    static let PollenConcentration: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A75"), gattName: "Pollen Concentration")
    static let PositionQuality: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A69"), gattName: "Position Quality")
    static let Pressure: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A6D"), gattName: "Pressure")
    static let ProtocolMode: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A4E"), gattName: "Protocol Mode")
    static let Rainfall: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A78"), gattName: "Rainfall")
    static let ReconnectionAddress: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A03"), gattName: "Reconnection Address")
    static let RecordAccessControlPoint: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A52"), gattName: "Record Access Control Point")
    static let ReferenceTimeInformation: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A14"), gattName: "Reference Time Information")
    static let Report: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A4D"), gattName: "Report")
    static let ReportMap: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A4B"), gattName: "Report Map")
    static let RestingHeartRate: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A92"), gattName: "Resting Heart Rate")
    static let RingerControlPoint: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A40"), gattName: "Ringer Control Point")
    static let RingerSetting: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A41"), gattName: "Ringer Setting")
    static let RSCFeature: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A54"), gattName: "RSC Feature")
    static let RSCMeasurement: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A53"), gattName: "RSC Measurement")
    static let SCControlPoint: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A55"), gattName: "SC Control Point")
    static let ScanIntervalWindow: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A4F"), gattName: "Scan Interval Window")
    static let ScanRefresh: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A31"), gattName: "Scan Refresh")
    static let SensorLocation: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A5D"), gattName: "Sensor Location")
    static let SerialNumberString: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A25"), gattName: "Serial Number String")
    static let ServiceChanged: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A05"), gattName: "Service Changed")
    static let SoftwareRevisionString: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A28"), gattName: "Software Revision String")
    static let SportTypeForAerobicAndAnaerobicThresholds: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A93"), gattName: "Sport Type for Aerobic and Anaerobic Thresholds")
    static let SupportedNewAlertCategory: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A47"), gattName: "Supported New Alert Category")
    static let SupportedUnreadAlertCategory: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A48"), gattName: "Supported Unread Alert Category")
    static let SystemID: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A23"), gattName: "System ID")
    static let Temperature: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A6E"), gattName: "Temperature")
    static let TemperatureMeasurement: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A1C"), gattName: "Temperature Measurement")
    static let TemperatureType: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A1D"), gattName: "TemperatureType")
    static let ThreeZoneHeartRateLimits: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A94"), gattName: "Three Zone Heart Rate Limits")
    static let TimeAccuracy: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A12"), gattName: "Time Accuracy")
    static let TimeSource: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A13"), gattName: "Time Source")
    static let TimeUpdateControlPoint: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A16"), gattName: "Time Update Control Point")
    static let TimeUpdateState: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A17"), gattName: "Time Update State")
    static let TimeWithDST: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A11"), gattName: "Time with DST")
    static let TimeZone: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A0E"), gattName: "Time Zone")
    static let TrueWindDirection: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A71"), gattName: "True Wind Direction")
    static let TrueWindSpeed: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A70"), gattName: "True Wind Speed")
    static let TwoZoneHeartRateLimit: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A95"), gattName: "Two Zone Heart Rate Limit")
    static let TxPowerLevel: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A07"), gattName: "Tx Power Level")
    static let Uncertainty: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2AB4"), gattName: "Uncertainty")
    static let UnreadAlertStatus: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A45"), gattName: "Unread Alert Status")
    static let UserControlPoint: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A9F"), gattName: "User Control Point")
    static let UserIndex: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A9A"), gattName: "User Index")
    static let UVIndex: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A76"), gattName: "UV Index")
    static let VO2Max: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A96"), gattName: "VO2 Max")
    static let WaistCircumference: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A97"), gattName: "Waist Circumference")
    static let Weight: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A98"), gattName: "Weight")
    static let WeightMeasurement: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A9D"), gattName: "Weight Measurement")
    static let WeightScaleFeature: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A9E"), gattName: "Weight Scale Feature")
    static let WindChill: GattUUID = GattUUID(assignedNumber: CBUUID(string: "0x2A79"), gattName: "Wind Chill")
    
    static let LegacyDFUControlPoint: GattUUID = GattUUID(assignedNumber: CBUUID(string: "00001531-1212-EFDE-1523-785FEABCD123"), gattName: "Legacy DFU Control Point")
    static let LegacyDFUPacket: GattUUID = GattUUID(assignedNumber: CBUUID(string: "00001532-1212-EFDE-1523-785FEABCD123"), gattName: "Legacy DFU Packet")
    static let LegacyDFUStatusReport: GattUUID = GattUUID(assignedNumber: CBUUID(string: "00001533-1212-EFDE-1523-785FEABCD123"), gattName: "Legacy DFU Status Report")
    static let LegacyDFURevision: GattUUID = GattUUID(assignedNumber: CBUUID(string: "00001534-1212-EFDE-1523-785FEABCD123"), gattName: "Legacy DFU Revision")
    
    static let SecureDFUControlPoint: GattUUID = GattUUID(assignedNumber: CBUUID(string: "8EC90001-F315-4F60-9FB8-838830DAEA50"), gattName: "Secure DFU Control Point")
    static let SecureDFUPacket: GattUUID = GattUUID(assignedNumber: CBUUID(string: "8EC90002-F315-4F60-9FB8-838830DAEA50"), gattName: "Secure DFU Packet")
    
    static let ExperimentalButtonlessDFUControlPoint: GattUUID = GattUUID(assignedNumber: CBUUID(string: "8E400001-F315-4F60-9FB8-838830DAEA50"), gattName: "Experimental Buttonless DFU Control Point")
    
    static let NORDIC_UART_RX: GattUUID = GattUUID(assignedNumber: CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"), gattName: "Nordic UART RX")
    static let NORDIC_UART_TX: GattUUID = GattUUID(assignedNumber: CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"), gattName: "Nordic UART TX")
    
    static let BeaconUUID: GattUUID = GattUUID(assignedNumber: CBUUID(string: "955A1524-0FE2-F5AA-A094-84B8D4F3E8AD"), gattName: "Beacon UUID")
    static let BeaconRSSI: GattUUID = GattUUID(assignedNumber: CBUUID(string: "955A1525-0FE2-F5AA-A094-84B8D4F3E8AD"), gattName: "Beacon RSSI")
    static let BeaconMajorMinor: GattUUID = GattUUID(assignedNumber: CBUUID(string: "955A1526-0FE2-F5AA-A094-84B8D4F3E8AD"), gattName: "Beacon Major Minor")
    static let BeaconManufactureID: GattUUID = GattUUID(assignedNumber: CBUUID(string: "955A1527-0FE2-F5AA-A094-84B8D4F3E8AD"), gattName: "Beacon Manufacture ID")
    static let BeaconConnInterval: GattUUID = GattUUID(assignedNumber: CBUUID(string: "955A1528-0FE2-F5AA-A094-84B8D4F3E8AD"), gattName: "Beacon Conn Interval")
    static let BeaconLED: GattUUID = GattUUID(assignedNumber: CBUUID(string: "955A1529-0FE2-F5AA-A094-84B8D4F3E8AD"), gattName: "Beacon LED")
    static let NordicBlinkyButton: GattUUID = GattUUID(assignedNumber: CBUUID(string: "00001524-1212-EFDE-1523-785FEABCD123"), gattName: "Nordic Blinky Button")
    static let NordicBlinkyLED: GattUUID = GattUUID(assignedNumber: CBUUID(string: "00001525-1212-EFDE-1523-785FEABCD123"), gattName: "Nordic Blinky LED")
    
    //MARK: -THINGY UUIDS - CONFIGURATION
    
    static let ThingyDeviceName: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680101-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Device Name")
    static let ThingyAdvertisingParam: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680102-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Configuration Service")
    static let ThingyConnectionParam: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680104-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Connection Param")
    static let ThingyCloudToken: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680106-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Cloud Token")
    static let ThingyEddystoneURL: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680105-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Eddystone URL")
    static let ThingyFWVersion: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680107-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy FW Version")
    static let ThingyMTURequest: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680108-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy MTU Request")
    
    //MARK: -THINGY UUIDS - Environment BLE Service
    
    static let ThingyTemperature: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680201-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Temperature")
    static let ThingyPressure: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680202-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Pressure")
    static let ThingyHumidity: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680203-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Humidity")
    static let ThingyGas: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680204-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Gas(Air quality)")
    static let ThingyColor: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680205-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Color")
    static let ThingyEnvironmentConfiguration: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680206-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Environment Configuration")

    //MARK: -THINGY UUIDS - User Interface
    
    static let ThingyLED: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680301-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy LED")
    static let ThingyButton: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680302-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Button")
    static let ThingyEXTPin: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680303-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy EXT Pin")
    
    //MARK: -THINGY UUIDS - Motion
    static let ThingyMotionConfiguration: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680401-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Motion Configuration")
    static let ThingyMotionTap: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680402-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Motion Tap")
    static let ThingyOrientation: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680403-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Orientation")
    static let ThingyQuaternion: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680404-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Quaternion")
    static let ThingyPedometer: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680405-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Pedometer")
    static let ThingyRawData: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680406-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Raw Data")
    static let ThingyEuler: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680407-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Euler")
    static let ThingyRotationMatrix: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680408-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Rotation Matrix")
    static let ThingyHeading: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680409-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Heading")
    static let ThingyGravityVector: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF68040A-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Gravity Vector")
    
    //MARK: -THINGY UUIDS - SOUND
    static let ThingySoundConfiguration: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680501-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Sound Configuration")
    static let ThingySpeakerData: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680502-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Speaker Data")
    static let ThingySpeakerStatus: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680503-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Speaker Status ")
    static let ThingyMicrophone: GattUUID = GattUUID(assignedNumber: CBUUID(string: "EF680504-9B35-4933-9B10-52FFA9740042"), gattName: "Thingy Microphone")
    
    
    //MARK: -APPLE UUIDS - NOTIFICATION CENTER
    static let AppleNotificationSource: GattUUID = GattUUID(assignedNumber: CBUUID(string: "9FBF120D-6301-42D9-8C58-25E699A21DBD"), gattName: "Apple Notification Source")
    static let AppleControlPoint: GattUUID = GattUUID(assignedNumber: CBUUID(string: "69D1D8F3-45E1-49A8-9821-9BBDFDAAD9D9"), gattName: "Apple Control Point")
    static let AppleDataSource: GattUUID = GattUUID(assignedNumber: CBUUID(string: "22EAC6E9-24D6-4BB5-BE44-B36ACE7C7BFB"), gattName: "Apple Data Source")
    
    //MARK: -APPLE UUIDS - NOTIFICATION CENTER
    static let AppleRemoteCommand: GattUUID = GattUUID(assignedNumber: CBUUID(string: "9B3C81D8-57B1-4A8A-B8DF-0E56F7CA51C2"), gattName: "Apple Remote Command")
    static let AppleEntityUpdate: GattUUID = GattUUID(assignedNumber: CBUUID(string: "2F7CABCE-808D-411F-9A0C-BB92BA96C102"), gattName: "Apple Entity Update")
    static let AppleEntityAttribute: GattUUID = GattUUID(assignedNumber: CBUUID(string: "C6B2F38C-23AB-46D8-A6AB-A3A870BBD5D7"), gattName: "Apple Entity Attribute")
    
    //MARK: -MICRO:BIT - ACCELEROMETER SERVICE - CHARACTERISTICS
    static let MicrobitAccelerometerData: GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95DCA4B-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Accelerometer Data")
    static let MicrobitAccelerometerPeriod: GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95DFB24-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Accelerometer Period")
    
    static let MicrobitMagnetometerData: GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95DFB11-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Magnetometer Data")
    static let MicrobitMagnetometerPeriod: GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95D386C-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Magnetometer Period")
    static let MicrobitMagnetometerBearing: GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95D9715-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Magnetometer Bearing")
    
    static let MicrobitButtonAState: GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95DDA90-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Button A State")
    static let MicrobitButtonBState: GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95DDA91-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Button B State")
    
    static let MicrobitPinData: GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95D8D00-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Pin Data")
    static let MicrobitPinADConfiguration: GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95D5899-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Pin AD Configuration")
    static let MicrobitPinIOConfiguration: GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95DB9FE-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Pin I/O Configuration")

    static let MicrobitPWMControl: GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95DD822-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit PWM Control")
    
    static let MicrobitLEDMatrixState: GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95D7B77-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit LED Matrix State")
    static let MicrobitLEDText: GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95D93EE-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit LED Text")
    static let MicrobitScrollingDelay: GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95D0D2D-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Scrolling Delay")
    static let MicrobitRequirements: GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95DB84C-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Requirements")
    
    static let MicrobitEvent: GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95D9775-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Event")
    static let MicrobitClientRequirements: GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95D23C4-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Client Requirements")
    static let MicrobitClientEvent: GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95D5404-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Client Event")
    
    static let MicrobitDFUControl: GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95D93B1-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit DFU Control")

    static let MicrobitTemperature: GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95D9250-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Temperature")
    static let MicrobitTemperaturePeriod: GattUUID = GattUUID(assignedNumber: CBUUID(string: "E95D1B25-251D-470A-A062-FA1922DFA9A8"), gattName: "micro:bit Temperature Period")
    
    static let gattCharacteristicUuids: [String: GattUUID] = [
    "0x2A7E": AerobicHeartRateLowerLimit,
    "0x2A84": AerobicHeartRateUpperLimit,
    "0x2A7F": AerobicThreshold,
    "0x2A80": Age,
    "0x2A5A": Aggregate,
    "0x2A43": AlertCategoryID,
    "0x2A42": AlertCategoryIDBitMask,
    "0x2A06": AlertLevel,
    "0x2A44": AlertNotificationControlPoint,
    "0x2A3F": AlertStatus,
    "0x2AB3": Altitude,
    "0x2A81": AnaerobicHeartRateLowerLimit,
    "0x2A82": AnaerobicHeartRateUpperLimit,
    "0x2A83": AnaerobicThreshold,
    "0x2A58": Analog,
    "0x2A73": ApparentWindDirection,
    "0x2A72": ApparentWindSpeed,
    "0x2A01": Appearance,
    "0x2AA3": BarometricPressureTrend,
    "0x2A19": BatteryLevel,
    "0x2A49": BloodPressureFeature,
    "0x2A35": BloodPressureMeasurement,
    "0x2A9B": BodyCompositionFeature,
    "0x2A9C": BodyCompositionMeasurement,
    "0x2A38": BodySensorLocation,
    "0x2AA4": BondManagementControlPoint,
    "0x2AA5": BondManagementFeature,
    "0x2A22": BootKeyboardInputReport,
    "0x2A32": BootKeyboardOutputReport,
    "0x2A33": BootMouseInputReport,
    "0x2AA6": CentralAddressResolution,
    "0x2AA8": CGMFeature,
    "0x2AA7": CGMMeasurement,
    "0x2AAB": CGMSessionRunTime,
    "0x2AAA": CGMSessionStartTime,
    "0x2AAC": CGMSpecificOpsControlPoint,
    "0x2AA9": CGMStatus,
    "0x2A5C": CSCFeature,
    "0x2A5B": CSCMeasurement,
    "0x2A2B": CurrentTime,
    "0x2A66": CyclingPowerControlPoint,
    "0x2A65": CyclingPowerFeature,
    "0x2A63": CyclingPowerMeasurement,
    "0x2A64": CyclingPowerVector,
    "0x2A99": DatabaseChangeIncrement,
    "0x2A85": DateOfBirth,
    "0x2A86": DateOfThresholdAssessment,
    "0x2A08": DateTime,
    "0x2A0A": DayDateTime,
    "0x2A09": DayOfWeek,
    "0x2A7D": DescriptorValueChanged,
    "0x2A00": DeviceName,
    "0x2A7B": DewPoint,
    "0x2A56": Digital,
    "0x2A0D": DSTOffset,
    "0x2A6C": Elevation,
    "0x2A87": EmailAddress,
    "0x2A0C": ExactTime256,
    "0x2A88": FatBurnHeartRateLowerLimit,
    "0x2A89": FatBurnHeartRateUpperLimit,
    "0x2A26": FirmwareRevisionString,
    "0x2A8A": FirstName,
    "0x2A8B": FiveZoneHeartRateLimits,
    "0x2AB2": FloorNumber,
    "0x2A8C": Gender,
    "0x2A51": GlucoseFeature,
    "0x2A18": GlucoseMeasurement,
    "0x2A34": GlucoseMeasurementContext,
    "0x2A74": GustFactor,
    "0x2A27": HardwareRevisionString,
    "0x2A39": HeartRateControlPoint,
    "0x2A8D": HeartRateMax,
    "0x2A37": HeartRateMeasurement,
    "0x2A7A": HeatIndex,
    "0x2A8E": Height,
    "0x2A4C": HIDControlPoint,
    "0x2A4A": HIDInformation,
    "0x2A8F": HipCircumference,
    "0x2A6F": Humidity,
    "0x2A2A": IEEE11073_20601RegulatoryCertificationDataList,
    "0x2AAD": IndoorPositioningConfiguration,
    "0x2A36": IntermediateCuffPressure,
    "0x2A1E": IntermediateTemperature,
    "0x2A77": Irradiance,
    "0x2AA2": Language,
    "0x2A90": LastName,
    "0x2AAE": Latitude,
    "0x2A6B": LNControlPoint,
    "0x2A6A": LNFeature,
    "0x2AB1": LocalEastCoordinate,
    "0x2AB0": LocalNorthCoordinate,
    "0x2A0F": LocalTimeInformation,
    "0x2A67": LocationAndSpeed,
    "0x2AB5": LocationName,
    "0x2AAF": Longitude,
    "0x2A2C": MagneticDeclination,
    "0x2AA0": MagneticFluxDensity_2D,
    "0x2AA1": MagneticFluxDensity_3D,
    "0x2A29": ManufacturerNameString,
    "0x2A91": MaximumRecommendedHeartRate,
    "0x2A21": MeasurementInterval,
    "0x2A24": ModelNumberString,
    "0x2A68": Navigation,
    "0x2A46": NewAlert,
    "0x2A04": PeripheralPreferredConnectionParameters,
    "0x2A02": PeripheralPrivacyFlag,
    "0x2A5F": PLXContinuousMeasurement,
    "0x2A60": PLXFeatures,
    "0x2A5E": PLXSpotCheckMeasurement,
    "0x2A50": PnPID,
    "0x2A75": PollenConcentration,
    "0x2A69": PositionQuality,
    "0x2A6D": Pressure,
    "0x2A4E": ProtocolMode,
    "0x2A78": Rainfall,
    "0x2A03": ReconnectionAddress,
    "0x2A52": RecordAccessControlPoint,
    "0x2A14": ReferenceTimeInformation,
    "0x2A4D": Report,
    "0x2A4B": ReportMap,
    "0x2A92": RestingHeartRate,
    "0x2A40": RingerControlPoint,
    "0x2A41": RingerSetting,
    "0x2A54": RSCFeature,
    "0x2A53": RSCMeasurement,
    "0x2A55": SCControlPoint,
    "0x2A4F": ScanIntervalWindow,
    "0x2A31": ScanRefresh,
    "0x2A5D": SensorLocation,
    "0x2A25": SerialNumberString,
    "0x2A05": ServiceChanged,
    "0x2A28": SoftwareRevisionString,
    "0x2A93": SportTypeForAerobicAndAnaerobicThresholds,
    "0x2A47": SupportedNewAlertCategory,
    "0x2A48": SupportedUnreadAlertCategory,
    "0x2A23": SystemID,
    "0x2A6E": Temperature,
    "0x2A1C": TemperatureMeasurement,
    "0x2A1D": TemperatureType,
    "0x2A94": ThreeZoneHeartRateLimits,
    "0x2A12": TimeAccuracy,
    "0x2A13": TimeSource,
    "0x2A16": TimeUpdateControlPoint,
    "0x2A17": TimeUpdateState,
    "0x2A11": TimeWithDST,
    "0x2A0E": TimeZone,
    "0x2A71": TrueWindDirection,
    "0x2A70": TrueWindSpeed,
    "0x2A95": TwoZoneHeartRateLimit,
    "0x2A07": TxPowerLevel,
    "0x2AB4": Uncertainty,
    "0x2A45": UnreadAlertStatus,
    "0x2A9F": UserControlPoint,
    "0x2A9A": UserIndex,
    "0x2A76": UVIndex,
    "0x2A96": VO2Max,
    "0x2A97": WaistCircumference,
    "0x2A98": Weight,
    "0x2A9D": WeightMeasurement,
    "0x2A9E": WeightScaleFeature,
    "0x2A79": WindChill,
    "00001531-1212-EFDE-1523-785FEABCD123": LegacyDFUControlPoint,
    "00001532-1212-EFDE-1523-785FEABCD123": LegacyDFUPacket,
    "00001533-1212-EFDE-1523-785FEABCD123": LegacyDFUStatusReport,
    "00001534-1212-EFDE-1523-785FEABCD123": LegacyDFURevision,
    "8EC90001-F315-4F60-9FB8-838830DAEA50": SecureDFUControlPoint,
    "8EC90002-F315-4F60-9FB8-838830DAEA50": SecureDFUPacket,
    "8E400001-F315-4F60-9FB8-838830DAEA50": ExperimentalButtonlessDFUControlPoint,
    "6E400002-B5A3-F393-E0A9-E50E24DCCA9E": NORDIC_UART_RX,
    "6E400003-B5A3-F393-E0A9-E50E24DCCA9E": NORDIC_UART_TX,
    "955A1524-0FE2-F5AA-A094-84B8D4F3E8AD": BeaconUUID,
    "955A1525-0FE2-F5AA-A094-84B8D4F3E8AD": BeaconRSSI,
    "955A1526-0FE2-F5AA-A094-84B8D4F3E8AD": BeaconMajorMinor,
    "955A1527-0FE2-F5AA-A094-84B8D4F3E8AD": BeaconManufactureID,
    "955A1528-0FE2-F5AA-A094-84B8D4F3E8AD": BeaconConnInterval,
    "955A1529-0FE2-F5AA-A094-84B8D4F3E8AD": BeaconLED,
    "00001524-1212-EFDE-1523-785FEABCD123": NordicBlinkyButton,
    "00001525-1212-EFDE-1523-785FEABCD123": NordicBlinkyLED,
    "EF680101-9B35-4933-9B10-52FFA9740042": ThingyDeviceName,
    "EF680102-9B35-4933-9B10-52FFA9740042": ThingyAdvertisingParam,
    "EF680104-9B35-4933-9B10-52FFA9740042": ThingyConnectionParam,
    "EF680105-9B35-4933-9B10-52FFA9740042":  ThingyEddystoneURL,
    "EF680106-9B35-4933-9B10-52FFA9740042": ThingyCloudToken,
    "EF680107-9B35-4933-9B10-52FFA9740042": ThingyFWVersion,
    "EF680108-9B35-4933-9B10-52FFA9740042": ThingyMTURequest,
    "EF680201-9B35-4933-9B10-52FFA9740042": ThingyTemperature,
    "EF680202-9B35-4933-9B10-52FFA9740042": ThingyPressure,
    "EF680203-9B35-4933-9B10-52FFA9740042": ThingyHumidity,
    "EF680204-9B35-4933-9B10-52FFA9740042": ThingyGas,
    "EF680205-9B35-4933-9B10-52FFA9740042": ThingyColor,
    "EF680206-9B35-4933-9B10-52FFA9740042": ThingyEnvironmentConfiguration,
    "EF680301-9B35-4933-9B10-52FFA9740042": ThingyLED,
    "EF680302-9B35-4933-9B10-52FFA9740042": ThingyButton,
    "EF680303-9B35-4933-9B10-52FFA9740042": ThingyEXTPin,
    "EF680401-9B35-4933-9B10-52FFA9740042": ThingyMotionConfiguration,
    "EF680402-9B35-4933-9B10-52FFA9740042": ThingyMotionTap,
    "EF680403-9B35-4933-9B10-52FFA9740042": ThingyOrientation,
    "EF680404-9B35-4933-9B10-52FFA9740042": ThingyQuaternion,
    "EF680405-9B35-4933-9B10-52FFA9740042": ThingyPedometer,
    "EF680406-9B35-4933-9B10-52FFA9740042": ThingyRawData,
    "EF680407-9B35-4933-9B10-52FFA9740042": ThingyEuler,
    "EF680408-9B35-4933-9B10-52FFA9740042": ThingyRotationMatrix,
    "EF680409-9B35-4933-9B10-52FFA9740042": ThingyHeading,
    "EF68040A-9B35-4933-9B10-52FFA9740042": ThingyGravityVector,
    "EF680501-9B35-4933-9B10-52FFA9740042": ThingySoundConfiguration,
    "EF680502-9B35-4933-9B10-52FFA9740042": ThingySpeakerData,
    "EF680503-9B35-4933-9B10-52FFA9740042": ThingySpeakerStatus,
    "EF680504-9B35-4933-9B10-52FFA9740042": ThingyMicrophone,
    "9FBF120D-6301-42D9-8C58-25E699A21DBD": AppleNotificationSource,
    "69D1D8F3-45E1-49A8-9821-9BBDFDAAD9D9": AppleControlPoint,
    "22EAC6E9-24D6-4BB5-BE44-B36ACE7C7BFB": AppleDataSource,
    "9B3C81D8-57B1-4A8A-B8DF-0E56F7CA51C2": AppleRemoteCommand,
    "2F7CABCE-808D-411F-9A0C-BB92BA96C102": AppleEntityUpdate,
    "C6B2F38C-23AB-46D8-A6AB-A3A870BBD5D7": AppleEntityAttribute,
    "E95DCA4B-251D-470A-A062-FA1922DFA9A8": MicrobitAccelerometerData,
    "E95DFB24-251D-470A-A062-FA1922DFA9A8": MicrobitAccelerometerPeriod,
    "E95DFB11-251D-470A-A062-FA1922DFA9A8": MicrobitMagnetometerData,
    "E95D386C-251D-470A-A062-FA1922DFA9A8": MicrobitMagnetometerPeriod,
    "E95D9715-251D-470A-A062-FA1922DFA9A8": MicrobitMagnetometerBearing,
    "E95DDA90-251D-470A-A062-FA1922DFA9A8": MicrobitButtonAState,
    "E95DDA91-251D-470A-A062-FA1922DFA9A8": MicrobitButtonBState,
    "E95D8D00-251D-470A-A062-FA1922DFA9A8": MicrobitPinData,
    "E95D5899-251D-470A-A062-FA1922DFA9A8": MicrobitPinADConfiguration,
    "E95DB9FE-251D-470A-A062-FA1922DFA9A8": MicrobitPinIOConfiguration,
    "E95DD822-251D-470A-A062-FA1922DFA9A8": MicrobitPWMControl,
    "E95D7B77-251D-470A-A062-FA1922DFA9A8": MicrobitLEDMatrixState,
    "E95D93EE-251D-470A-A062-FA1922DFA9A8": MicrobitLEDText,
    "E95D0D2D-251D-470A-A062-FA1922DFA9A8": MicrobitScrollingDelay,
    "E95DB84C-251D-470A-A062-FA1922DFA9A8": MicrobitRequirements,
    "E95D9775-251D-470A-A062-FA1922DFA9A8": MicrobitEvent,
    "E95D23C4-251D-470A-A062-FA1922DFA9A8": MicrobitClientRequirements,
    "E95D5404-251D-470A-A062-FA1922DFA9A8": MicrobitClientEvent,
    "E95D93B1-251D-470A-A062-FA1922DFA9A8": MicrobitDFUControl,
    "E95D9250-251D-470A-A062-FA1922DFA9A8": MicrobitTemperature,
    "E95D1B25-251D-470A-A062-FA1922DFA9A8": MicrobitTemperaturePeriod]

    static func getChracteristicName(_ uuid: CBUUID) ->String
    {
        var valueName = ""
        var result : GattUUID!
        for value in self.gattCharacteristicUuids.values
        {
            if value.AssignedNumber == uuid {
                result = value
                break
            }
        }
        if let gattUUID = result
        {
            valueName = gattUUID.GattName
        }
        return valueName
    }
    
    static func getUUIDPrefix(uuid: CBUUID) -> String {
        var uuidPrefix = ""
        let result = self.gattCharacteristicUuids.filter { (x) -> Bool in
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
}
