//
//  DatFileViewModel.swift
//  nRFConnect
//
//  Created by Jiajun Qiu on 15/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import iOSDFULibrary

class DatFileViewModel: FileViewModelBase {
    private(set) var cellViewModel = [DatFileTableCellViewModel]()
    private(set) var selectedRow: DatFileTableCellViewModel!
    var isDatFileFound = false
    
    var firmware: LegacyDFUFile!
    var navigationButtonStatus: NavigationButtonStatus = .skip

    enum NavigationButtonStatus: String {
        case next = "Next"
        case skip = "Skip"
    }
    
    override init() {
        super.init()
        self.cellViewModel = self.getCellViewModel(cellViewModel: &cellViewModel).getDatFile()
        if self.cellViewModel.count > 0 {
            isDatFileFound = true
        } else {
            isDatFileFound = false
        }
    }
    
    func setSelectRow(atRow: Int) {
        self.selectedRow = self.cellViewModel[atRow]
    }
    
    func userDoneSelection() {
        
    }
    
    func unsetSelectRow() {
        self.selectedRow = nil
    }
    
    func modifyFirmware() -> LegacyDFUFile {
        if selectedRow != nil && firmware != nil {
            self.firmware.firmwareDatURL = selectedRow.fileURL
        } else if selectedRow == nil && firmware != nil {
            self.firmware.firmwareDatURL = nil
        }
        return self.firmware
    }
    
    func removeCell(atRow: Int) {
        if selectedRow != nil && selectedRow.fileName == self.cellViewModel[atRow].fileName {
            selectedRow = nil
        }
        let fileURL = self.cellViewModel[atRow].fileURL
        removeFile(url: fileURL)
        self.cellViewModel.remove(at: atRow)
    }
}
