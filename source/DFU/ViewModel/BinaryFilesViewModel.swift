//
//  AppFilesViewModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 29/11/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import iOSDFULibrary

class BinaryFilesViewModel: FileViewModelBase {
    var cellViewModel: [BinaryFilesTableCellViewModel] = []
    fileprivate(set) var selectedRow: BinaryFilesTableCellViewModel!
    
    var firmware: LegacyDFUFile!
    
    override init() {
        super.init()
        self.cellViewModel = self.getCellViewModel(cellViewModel: &self.cellViewModel).getHexOrBinFile()
    }
    
    func setSelectRow(index: IndexPath) {
        self.selectedRow = self.cellViewModel[index.row]
    }
    
    func unsetSelectRow() {
        self.selectedRow = nil
    }
    
    func removeCell(atRow: Int) {
        if selectedRow != nil && selectedRow.fileName == self.cellViewModel[atRow].fileName {
            selectedRow = nil
        }
        let fileURL = self.cellViewModel[atRow].fileURL
        removeFile(url: fileURL)
        self.cellViewModel.remove(at: atRow)
    }
    
    func modifyFirmware() -> LegacyDFUFile? {
        if selectedRow != nil && firmware == nil {
            self.firmware = LegacyDFUFile(firmwareURL: selectedRow.fileURL)
        } else if selectedRow == nil && firmware != nil {
            self.firmware = nil
        }
        return self.firmware
    }
    
    func isFirmwareReady() -> Bool {
        var isReady: Bool = false
        guard self.firmware != nil else {
            return isReady
        }
        if self.firmware.firmwareSize != nil && self.firmware.firmwareSize! >= 0 {
            isReady = true
        }
        return isReady
    }
}


