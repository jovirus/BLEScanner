//
//  DataHandelingMessage.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 24/03/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
public enum DataHandelingMessage: String {
    case convertedData = "[Data]Converted data"
    case errorOccursConverting = "[Data]Error occurs when converting"
    case newData = "[Data]New data"
    case nilData = "[Data]Data is nil"
}
