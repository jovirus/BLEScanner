//
//  FirmwareInfoCellViewModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 23/02/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
class FirmwareInfoCellViewModel {
    var title: String = ""
    var value: String = ""
    
   required init(title: String, value: String) {
        self.title = title
        self.value = value
    }
}
