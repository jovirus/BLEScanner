//
//  ViewModelBase.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 29/10/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import CoreBluetooth

open class ViewModelBase: GenericViewModel {
    // MARK: status bar
    let CONNECTION_STATUS_CONNECTED = BLEConnectStatus.connected.description()
    let CONNECTION_STATUS_DISCONNECTED = BLEConnectStatus.disconnected.description()
    let CONNECTION_STATUS_CONNECTING = BLEConnectStatus.connecting.description()
    let CONNECTION_STATUS_DISCONNECTING = BLEConnectStatus.disconnecting.description()
    var isDataTimeOut: Bool = false

    func findCell<T: CellViewModelBase>(_ uuid: CBUUID, gattViewCell: [T]) -> T? {
        var targetCellViewModel: T?
        let result = gattViewCell.filter{ (x) in x.UUID == uuid }
        if let cell = result.first
        {
            targetCellViewModel = cell
        }
        return targetCellViewModel
    }
}
