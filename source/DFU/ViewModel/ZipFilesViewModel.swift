//
//  UserFilesViewModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 30/11/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation

class ZipFilesViewModel: FileViewModelBase {
    static let HelperSection: Int = 0
    static let ZipFilesSection: Int = 1
    
    var cellViewModel: [ZipFilesTableCellViewModel] = []
    private(set) var selectedRow: ZipFilesTableCellViewModel!
    
    var firmware: SecurityDFUFile!
    
    override init() {
        super.init()
        self.cellViewModel = self.getCellViewModel(cellViewModel: &cellViewModel).getDistributionFile()
    }
    
    func removeCell(atRow: Int) {
        if selectedRow != nil && selectedRow.fileName == self.cellViewModel[atRow].fileName {
            selectedRow = nil
            removeFirmware()
        }
        let fileURL = self.cellViewModel[atRow].fileURL
        LocalAccessManager.instance.removeFiles(fileURL: fileURL)
        self.cellViewModel.remove(at: atRow)
    }
    
    func setSelectRow(atRow: Int) {
        self.selectedRow = self.cellViewModel[atRow]
    }
    
    func userDoneSelection() {
        
    }
    
    func unsetSelectRow() {
        self.selectedRow = nil
    }
    
    func creatFirmware() -> SecurityDFUFile? {
        if selectedRow != nil && firmware == nil {
            self.firmware = SecurityDFUFile(firmwareURL: selectedRow.fileURL)
        }
        return self.firmware
    }
    
    func removeFirmware() {
        self.firmware = nil
    }
    
    func isFirmwareReady() -> Bool {
        var isReady = false
        guard self.firmware != nil else {
            return isReady
        }
        isReady = LocalAccessManager.instance.isFileExist(url: self.firmware.firmwareURL)
        return isReady
    }
}
