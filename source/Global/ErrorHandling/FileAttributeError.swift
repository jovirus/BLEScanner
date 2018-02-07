//
//  FileAttributeError.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 22/03/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
/**
 The error appears when deserialize local files.
 */
public enum FileAttributeError: Error {
    case GetFileSizeError
    
    func toString() -> String {
        switch self {
        case .GetFileSizeError:
            return "[System]Get file size error."
        }
    }
}
