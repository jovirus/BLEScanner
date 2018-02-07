//
//  BeaconAdvertisementSpec.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 10/02/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation

internal class BeaconAdvertisementSpec
{
    internal var beaconTradeMark = ""
    fileprivate typealias beaconName = (id: String, tradeName: String)
    fileprivate let listOfBeaconTradeMarks: Dictionary<String, beaconName> = ["0xFEAA": ("0xFEAA", "Eddystone" + Symbols.TradeMark) , "0x0059": ("0x0059", "nRF Beacon")]
    
    internal func getBeaconTradeMark(_ id: String) -> String {
        let keyValuePair = listOfBeaconTradeMarks.filter({
            (key, value) in
            if key == id {
                return true
            }
            return false
        }).first
        
        if let(_, outValue) = keyValuePair {
            return outValue.tradeName
        }
        return ""
    }
}
