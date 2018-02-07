//
//  DeviceFilter.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 01/09/16.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import CoreBluetooth

internal struct DeviceFilterViewModel {
    private(set) var didUseNameFilter: Bool = false {
        didSet {
            if didUseNameFilter { advFilters[CBAdvertisementDataLocalNameKey] = [nameFilter] }
        }
    }
    var nameFilter: String = "" {
        didSet {
            didUseNameFilter = nameFilter != "" ? true : false
        }
    }
    private(set) var didUseDataFilterFilter: Bool = false {
        didSet {
            if didUseDataFilterFilter { advFilters[CBAdvertisementDataUUIDsFilterKey] = [deviceTypeFilter] }
        }
    }
    var deviceTypeFilter: DeviceTypeFilterEnum = .None {
        didSet {
            didUseDataFilterFilter = deviceTypeFilter != .None ? true : false
        }
    }
    private var didUseRSSIFilterFilter: Bool = false {
        didSet {
            if didUseRSSIFilterFilter { advFilters[CBAdvertisementSignalStrength] = [rssi] }
        }
    }
    var rssi: Float = -100.0 {
        didSet {
            didUseRSSIFilterFilter = rssi != -100 && rssi != 0 ? true : false
        }
    }
    private var didUseFavoriteFilterFilter: Bool = false {
        didSet {
            if didUseFavoriteFilterFilter { advFilters[CBFavoriteDeviceFilterKey] = [true] }
        }
    }
    var showOnlyFavourite = false {
        didSet {
            didUseFavoriteFilterFilter = showOnlyFavourite ? true : false
        }
    }
    //Stored deviceID
    var favourite: [String] = []
    let FAVOURITE = "favorites"
    let NO_FILTER = "No filter"
    private var filtersTextDescription = ""
    private(set) var advFilters: Dictionary<String, [Any] > = Dictionary()

    public mutating func description() -> String {
        if didUseNameFilter {
            filtersTextDescription = nameFilter + Symbols.semicolon
        }
        if didUseDataFilterFilter {
            filtersTextDescription += deviceTypeFilter.description() + Symbols.semicolon
        }
        if didUseRSSIFilterFilter {
            filtersTextDescription += rssiString() + Symbols.semicolon
        }
        if showOnlyFavourite {
            filtersTextDescription += self.FAVOURITE + Symbols.semicolon
        }
        return self.filtersTextDescription
    }
    
    func isFilterOn() -> Bool{
        return self.advFilters.count > 0
    }
    
    mutating func clearFilter() {
        self.nameFilter = ""
        self.filtersTextDescription = ""
        self.deviceTypeFilter = .None
        self.rssi = -100
        self.showOnlyFavourite = false
        self.advFilters.removeAll()
        self.favourite.removeAll()
    }
    
    func rssiString() -> String {
        let rssiString = String(Int(self.rssi)) + Symbols.dBm
        return rssiString
    }
    
    mutating func removeFromFavourite(_ deviceID: String) {
        if let index = self.favourite.index(of: deviceID) {
            favourite.remove(at: index)
        }
    }
    
    mutating func resetFilterStringText() {
        self.filtersTextDescription = ""
    }
}
