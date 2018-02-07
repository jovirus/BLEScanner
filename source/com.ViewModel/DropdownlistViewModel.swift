//
//  DropdownlistViewModel.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 10/05/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
class DropdownlistViewModel
{
    var listOfContents: [DropdownlistCellViewModel] = []

    init() {
        self.loadLogViewLevels()
    }
    
    func loadLogViewLevels() {
        let choices = [LogType.debug, LogType.verbose, LogType.info, LogType.application, LogType.warning, LogType.error]
        for item in choices {
            listOfContents.append(DropdownlistCellViewModel(logLevel: item))
        }
    }
}
