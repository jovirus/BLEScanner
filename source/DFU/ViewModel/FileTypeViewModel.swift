//
//  FileTypeViewModel.swift
//  nRFConnect
//
//  Created by Jiajun Qiu on 21/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation

class FileTypeViewModel {
    private(set) var cellViewModel = [FileTypeTableCellViewModel]()
    private(set) var selectedRow: FileTypeTableCellViewModel!
    
    var firmware: LegacyDFUFile!

    init() {
        initialFirmwareTypes()
    }
    
    func initialFirmwareTypes() {
        for type in DFUFirmwareTypeEnum.allType {
            let cellVM = FileTypeTableCellViewModel(firmwareType: type)
            self.cellViewModel.append(cellVM)
        }
    }
    
    func isFirmwareReady() -> Bool {
        var isReady: Bool = false
        if let result = self.firmware, let _ = result.firmwareType {
            isReady = true
        }
        return isReady
    }
    
    func modifyFirmware() -> LegacyDFUFile {
        if selectedRow != nil && firmware != nil {
            self.firmware.firmwareType = selectedRow.type
        }
        return self.firmware
    }
    
    func setSelectRow(atRow: Int) {
        self.selectedRow = self.cellViewModel[atRow]
    }
    
    func userDoneSelection() {
        
    }
    
    func unsetSelectRow() {
        self.selectedRow = nil
    }
}
