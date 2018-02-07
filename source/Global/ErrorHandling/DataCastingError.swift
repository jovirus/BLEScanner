//
//  DataCastException.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 19/02/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
/**
 The error appears when if data casting failed.
*/
public enum DataCastingError: Error {
        case invalidInput(input: String)
        case serializationFaild(error: NSError)
}
