//
//  DropdownlistCellViewModel.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 10/05/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
class DropdownlistCellViewModel
{
    var nameID: String!
    var logLevel: LogType!
    
    init(logLevel: LogType) {
        self.logLevel = logLevel
        self.nameID = String(describing: self.logLevel.description)
    }
}
