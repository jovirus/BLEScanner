//
//  DFUOperationMessage.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 24/03/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
public enum DFUOperationMessage: String {
    case stateChanged = "[Callback]State changed to"
    case errorOccurs = "[System]Error occurs when updating"
}
