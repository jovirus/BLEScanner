//
//  FileTypeTableCellViewModel.swift
//  nRFConnect
//
//  Created by Jiajun Qiu on 21/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit
import iOSDFULibrary

class FileTypeTableCellViewModel {
    
    var firmwareType: String?
    private(set) var type: DFUFirmwareType!
    
    init(firmwareType: String) {
        self.firmwareType = firmwareType
        self.type = DFUFirmwareTypeEnum.convertValue(description: firmwareType)
    }
}
