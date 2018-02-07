//
//  UserFilesTableCellViewModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 06/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
class ZipFilesTableCellViewModel: FilesTableViewCellViewModelBase {
    
}

extension Array where Element: ZipFilesTableCellViewModel {

    func getDistributionFile() -> [Element] {
        return self.filter { (x) -> Bool in
            if x.fileKind == .DistributionPackage {
                return true
            } else {
                return false
            }
        }
    }
}
