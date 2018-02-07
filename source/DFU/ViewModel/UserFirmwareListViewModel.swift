//
//  UserFirmwareListViewModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 02/01/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
protocol UserFirmwareListViewModelDelegate {
    func newFirmwareAdded(cell: UserFirmwareTableCellViewModel)
    func hasFileListModified(hasModified: Bool)
}

extension UserFirmwareListViewModel {
    enum contentStatus: String {
        case closeButton = "Close"
        case saveButton = "Save"
    }
}

class UserFirmwareListViewModel: DFUMainViewModelBase
{
    private(set) var userFirmwareCellVMList = [UserFirmwareTableCellViewModel]()
    var userFirmwareListViewModelDelegate: UserFirmwareListViewModelDelegate?
    private(set) var selectRow: UserFirmwareTableCellViewModel?
//    fileprivate var filesURLs: [URL]?
    
    fileprivate(set) var isFileListModified = false
    
//    fileprivate(set) var closeButton = "Close"
//    fileprivate(set) var saveButton = "Save"
    

    
    func addUserFirmware<T: DFUFileProtocol>(file: T) {
        let firmware = UserFirmwareTableCellViewModel(centralMananger: self.centralMananger, peripheral: self.peripheral, device: self.selectedDevice, session: self.session)
        firmware.setFirmware(file: file)
        self.userFirmwareCellVMList.append(firmware)
        self.userFirmwareListViewModelDelegate?.newFirmwareAdded(cell: firmware)
        isFileListModified = true
        self.userFirmwareListViewModelDelegate?.hasFileListModified(hasModified: isFileListModified)
    }
    
    func isFileExisted<T: DFUFileProtocol>(file: T) -> Bool {
        return self.userFirmwareCellVMList.contains(where: { (item) -> Bool in
            var isExist = false
            if item.dfuFile.firmwareURL.path == file.firmwareURL.path {
                isExist = true
            }
            return isExist
        })
    }
    
    func setSelectedRow(row: Int) {
        if self.userFirmwareCellVMList.count > row {
            self.selectRow = self.userFirmwareCellVMList[row]
        }
    }
    
    internal func saveUserFirmware() {
        guard self.isFileListModified else {
            return
        }
        let firmwareInfoList = UserFirmwareListPersist()
        firmwareInfoList.firmwareList = []
        for item in userFirmwareCellVMList {
            let firmwareInfo = UserFirmwarePersist()
            firmwareInfo.firmwareName = item.firmwareName
            firmwareInfo.firmwareSize = item.firmwareSize!
            firmwareInfo.firmwareKind = item.firmwareKind
            firmwareInfo.savedAt = item.savedAt
            if item.firmwareKind == DFUFileKind.Binary {
                let dfuFirmware = item.dfuFile as! LegacyDFUFile
                firmwareInfo.firmwareDatName = dfuFirmware.firmwareDatName != nil ? String(describing: dfuFirmware.firmwareDatName!) : nil
                firmwareInfo.firmwareType = DFUFirmwareTypeEnum.getValue(type: dfuFirmware.firmwareType)
            }
            firmwareInfoList.firmwareList?.append(firmwareInfo)
        }
        LocalAccessManager.instance.saveUserFirmwareList(firmwares: firmwareInfoList, completion: { (url, error) in
            if error == nil {
                self.isFileListModified = false
                self.userFirmwareListViewModelDelegate?.hasFileListModified(hasModified: self.isFileListModified)
            }
        }, session: self.session)
    }
    
    internal func restoreUserFirmware() -> Int {
        self.userFirmwareCellVMList.removeAll()
        var numbersOfSavedUserFirmware = 0
        if let result = LocalAccessManager.instance.readUserFirmwareList(completion: { (url, error) in
        }, session: self.session) {
            for item in result {
                let userFirmwareTableCellViewModel = UserFirmwareTableCellViewModel(centralMananger: self.centralMananger, peripheral: self.peripheral, device: self.selectedDevice, session: session)
                let fileURL = getUserFileURLs(fileName: item.firmwareName!)
                guard  fileURL != nil else {
                    return numbersOfSavedUserFirmware
                }
                if item.firmwareKind == DFUFileKind.DistributionPackage {
                    let distributionPackFile = SecurityDFUFile(firmwareURL: fileURL!, createdAt: item.savedAt!)
                    userFirmwareTableCellViewModel.setFirmware(file: distributionPackFile)
                } else if item.firmwareKind == DFUFileKind.Binary {
                    var datFileURL: URL? = nil
                    if let datName = item.firmwareDatName {
                        datFileURL = getUserFileURLs(fileName: datName)
                    }
                    let firmwareType = DFUFirmwareTypeEnum.convertValue(description: (item.firmwareType?.rawValue)!)
                    let binaryFile = LegacyDFUFile(firmwareURL: fileURL!, datFile: datFileURL, firmwareType: firmwareType!, createdAt: item.savedAt!)
                    userFirmwareTableCellViewModel.setFirmware(file: binaryFile)
                }
                self.userFirmwareCellVMList.append(userFirmwareTableCellViewModel)
            }
        }
        numbersOfSavedUserFirmware = userFirmwareCellVMList.count
        return numbersOfSavedUserFirmware
    }
    
    fileprivate func getUserFileURLs(fileName: String) -> URL? {
        if let externalfilesURLs = LocalAccessManager.instance.getExternalDFUFiles() {
            let result = getUserFileURLs(urls: externalfilesURLs, fileName: fileName)
            if result == nil {
                if let internalFilesURLs = LocalAccessManager.instance.getInternalDFUFiles() {
                    if let result = getUserFileURLs(urls: internalFilesURLs, fileName: fileName) {
                        return result
                    }
                }
            } else {
                return result
            }
        }
        return nil
    }
    
    fileprivate func getUserFileURLs(urls: [URL], fileName: String) -> URL? {
        var target: URL?
        target = urls.filter({ (item) -> Bool in
            var isTargetFile: Bool = false
            if item.lastPathComponent == fileName {
                isTargetFile = true
            }
            return isTargetFile
        }).first
        return target
    }
    
    internal func removeCell(atRow: Int) -> Bool {
        var isSuccessed = false
        guard self.userFirmwareCellVMList.count > atRow else {
            return isSuccessed
        }
            self.userFirmwareCellVMList.remove(at: atRow)
            isSuccessed = true
            isFileListModified = true
            self.userFirmwareListViewModelDelegate?.hasFileListModified(hasModified: isFileListModified)
        return isSuccessed
    }
}
