//
//  DataAccessError.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 11/04/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
public enum DataAccessError: Error {
    case poolNotExist

    func description() -> String {
        switch self {
        case .poolNotExist:
            return "Pool not exist"
        }
    }
}
