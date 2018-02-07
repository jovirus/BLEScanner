//
//  GenericViewModel.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 29/10/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import CoreBluetooth

 open class GenericViewModel: NSObject{
    fileprivate(set) var UUID: CBUUID!

    func setUUID(uuid: CBUUID) {
        self.UUID = uuid
    }
}
