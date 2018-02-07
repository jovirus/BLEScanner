//
//  GenericAttributeProfilesViewCell.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 14/08/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation

class GenericAttributeProfilesViewCell {
    var index: Int
    var serviceName: String
    var uuid: String
    var selected: Bool
    var isSearchResult: Bool
    private(set) var gattUUID: GattUUID
    
    init(index: Int, gatt: GattUUID, isSelected: Bool = false, isSearchResult: Bool = false) {
        self.index = index
        self.gattUUID = gatt
        self.serviceName = gatt.GattName
        self.uuid = gatt.AssignedNumber.uuidString
        self.selected = isSelected
        self.isSearchResult = isSearchResult
    }
}
