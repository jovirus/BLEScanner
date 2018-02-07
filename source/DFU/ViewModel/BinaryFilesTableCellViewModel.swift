//
//  AppFilesTableViewCellViewModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 29/11/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
class BinaryFilesTableCellViewModel : FilesTableViewCellViewModelBase {
    

}

extension Array where Element: BinaryFilesTableCellViewModel {
    
    func getHexOrBinFile() -> [Element] {
        return self.filter { (x) -> Bool in
            if x.fileKind == .Binary {
                return true
            } else {
                return false
            }
        }
    
    }
}
