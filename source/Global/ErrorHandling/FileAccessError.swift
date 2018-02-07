//
//  FileAccessException.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 24/11/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
/**
 The error appears when trys to access files.
 */
 public enum FileAccessError: Error {
        case BuldleAddressNotExisting
        case FailedToAccessFilePath
        case NoSuchFileFound
        case ReadFileFailed
        case DeleteFileFailed
        case SaveFileFailed
        case FileExisted
        case FileDownloadingFailed
        
        func getDescription() -> String {
            switch self {
            case .BuldleAddressNotExisting:
                return "[System]Buldle address not exist."
            case .FailedToAccessFilePath:
                return "[System]Accessing file path failed."
            case .NoSuchFileFound:
                return "[System]No such file found."
            case .ReadFileFailed:
                return "[System]Reading file failed."
            case .DeleteFileFailed:
                return "[System]Deleting file failed."
            case .SaveFileFailed:
                return "[System]Saving file failed."
            case .FileExisted:
                return "[System]File is already existed."
            case .FileDownloadingFailed:
                return "[System]Downloading file failed."
            }
        }
    }
