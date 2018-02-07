//
//  TableViewStatus.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 06/09/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
//MARK: The status is reflecting the UI changing of a table view .
enum TableViewStatus: Int {
    //user are able to view the contents normally
    case viewing = 0
    //the table is loading its contents
    case updating = 1
    //the table is letting the user to modify table contents
    case editing = 2
    //The table in not able to be edited
    case busying = 3
}
