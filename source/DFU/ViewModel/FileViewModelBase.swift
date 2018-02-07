//
//  DFUFileViewModelBase.swift
//  nRFConnect
//
//  Created by Jiajun Qiu on 16/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation

protocol FileViewModelProtocol: class {
    func getCellViewModel<T: FilesTableViewCellViewModelBase>(cellViewModel: inout [T]) -> [T]
    func removeFile(url: URL)
}

class FileViewModelBase: FileViewModelProtocol {
    
    internal func getCellViewModel<T: FilesTableViewCellViewModelBase>(cellViewModel: inout [T]) -> [T] {
        if let result = LocalAccessManager.instance.getExternalDFUFiles() {
            for url in result {
                let cellVM = T(fileURL: url)
                cellViewModel.append(cellVM)
            }
        }
        if let result = LocalAccessManager.instance.getInternalDFUFiles() {
            for url in result {
                let cellVM = T(fileURL: url)
                cellViewModel.append(cellVM)
            }
        }
        return cellViewModel
    }
    
    internal func removeFile(url: URL) {
        LocalAccessManager.instance.removeFiles(fileURL: url)
    }
}
