//
//  ViewModelBase.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 29/10/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import CoreBluetooth

open class CellViewModelBase: GenericViewModel {
    var cellIndex: Int?
    var Name: String = ""
    var Value: String = ""
    var isPushedToView: Bool = false
    
    func AssignCellIndex(_ index: Int) {
        self.cellIndex = index
    }
}
