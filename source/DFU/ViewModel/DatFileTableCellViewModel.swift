//
//  DatFileTableCellViewModel.swift
//  nRFConnect
//
//  Created by Jiajun Qiu on 15/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
class DatFileTableCellViewModel: FilesTableViewCellViewModelBase {
    
}

extension Array where Element: DatFileTableCellViewModel {

    func getDatFile () -> [Element] {
        return self.filter { (x) -> Bool in
            if x.fileKind == .Dat {
                return true
            } else {
                return false
            }
        }
    }
}
