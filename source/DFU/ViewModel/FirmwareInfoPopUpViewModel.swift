//
//  FirmwareInfoPopUpViewModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 04/01/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

class FirmwareInfoPopUpViewModel {

    var firmwareType: DFUFileKind!
    var firmwareInfoList: [FirmwareInfoCellViewModel] = []
    
    let estimatedRowHeight = CGFloat(25)
    
    internal func addInfo (title: String, value: String) {
        let info = FirmwareInfoCellViewModel(title: title, value: value)
        self.firmwareInfoList.append(info)
    }
}
