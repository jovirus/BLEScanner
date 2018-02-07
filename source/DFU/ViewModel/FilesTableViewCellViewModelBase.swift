//
//  FilesTableViewCellViewModelBase.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 06/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
protocol FilesTableViewCellViewModelProtocol  {
    var fileName: String { get set }
    var fileURL: URL { get set }
    var fileKind: DFUFileKind { get set }
}

class FilesTableViewCellViewModelBase: FilesTableViewCellViewModelProtocol {

    internal var fileURL: URL
    internal var fileName: String = ""
    internal var fileKind: DFUFileKind

    required init(fileURL: URL) {
        self.fileName = LocalAccessManager.instance.getFullFileName(fileURL: fileURL)
        self.fileKind = LocalAccessManager.instance.getFileKind(fileURL: fileURL)
        self.fileURL = fileURL
    }
}


