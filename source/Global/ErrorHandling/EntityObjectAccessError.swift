//
//  EntityObjectAccessError.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 06/04/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
public enum EntityObjectAccessError: Error {
    case noDataFound
    case invalidCriteria
    
    
    func description() -> String {
        switch self {
        case .noDataFound:
            return "No data found on giving criteria"
        case .invalidCriteria:
            return "Invalid criterias"
        }
    }
}
