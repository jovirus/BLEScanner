//
//  FileAccessManager.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 09/05/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
import UIKit

protocol  FileAttributeProtocol {
    func getFileNameWithoutExtension(fileURL: URL) -> String!
    func getFullFileName(fileURL: URL) -> String!
    func getFileSize(fileURL: URL) -> UInt64!
    func getFileKind(fileURL: URL) -> DFUFileKind
}

class LocalAccessManager
{

    typealias CallBack = (_ path: URL, _ error: Error?) -> Void
    
    static var instance = LocalAccessManager()
    fileprivate let DFU_FOLDER_NAME = "DFU_Examples"
    
    fileprivate var logManager: LogManager!
    
    fileprivate init() {
        logManager = LogManager.instance
    }
    
//    //MARK: UserInfo handling
//    @available(*, deprecated: 1.8, message: "userDefault will be used")
//    func createUserInfo(userInfo: UserInfoList, completion: @escaping CallBack) {
//        DispatchQueue.main.async {
//        let documentsUrl =  FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first
//        let destinationUrl = documentsUrl!.appendingPathComponent("nRFConnect_UserInfo")
//        do {
//            try userInfo.toJsonString(.DefaultDeserialize).write(to: destinationUrl, atomically: true, encoding: String.Encoding.utf8)
//            completion(destinationUrl, nil)
//        } catch let error
//        {
//            completion(destinationUrl, error)
//        }
//      }
//    }
//    
//    func appendNewUserInfo(newInfo: UserInfoList, completion: CallBack) {
//        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//        let destinationUrl = documentsUrl!.appendingPathComponent("nRFConnect_UserInfo")
//        if FileManager().fileExists(atPath: destinationUrl.path) {
//            if let fileHandle = FileHandle(forWritingAtPath: destinationUrl.path) {
//                defer {
//                    fileHandle.closeFile()
//                }
//                fileHandle.seekToEndOfFile()
////                let separator = "****** New Line ******\n".data(using: String.Encoding.utf8)
//                let newInfoJson = newInfo.toJsonData(.DefaultDeserialize)
////                fileHandle.write(separator!)
//                fileHandle.write(newInfoJson)
//                completion(destinationUrl, nil)
//            }
//        } else {
//            completion(destinationUrl, FileAccessError.NoSuchFileFound)
//        }
//    }
//    @available(*, deprecated: 1.8, message: "userDefault will be used")
//    func readUserInfo(_ completion: @escaping CallBack) -> UserInfoList! {
//        var result: UserInfoList!
//        let documentsUrl =  FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first
//        let destinationUrl = documentsUrl!.appendingPathComponent("nRFConnect_UserInfo")
//        if FileManager().fileExists(atPath: destinationUrl.path) {
//            do {
//                let rawString = try String(contentsOf: destinationUrl, encoding: String.Encoding.utf8)
//                result = UserInfoList(json: rawString)
//                completion(destinationUrl, nil)
//            }
//            catch let error {
//                completion(destinationUrl, error)
//                }
//            }
//        return result
//    }
    
    //END MARK
    
    //MARK: APP data handling
    func readCompanyInfoFile(_ fileName: String) -> [CompanyIDPersist]?
    {
        let documentsUrl =  FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first
        let destinationUrl = documentsUrl!.appendingPathComponent(fileName)
        if FileManager().fileExists(atPath: destinationUrl.path) {
            do
            {
                let temp = try NSString(contentsOfFile: destinationUrl.path, encoding: String.Encoding.utf8.rawValue) as String
                let result = CompanyIDListPersist(json: temp)
                if let companyInfo = result.companies
                {
                    return companyInfo
                }
            }
            catch let error
            {
                NSLog("\(error.localizedDescription)")
            }
        }
        return nil
    }
    
    func getInternalDFUFiles() -> [URL]! {
        var files: [URL]!
        var fileURL = Bundle.main.resourceURL
        fileURL?.appendPathComponent(DFU_FOLDER_NAME)
        files = try? FileManager.default.contentsOfDirectory(at: fileURL!, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants)
        return files
    }
    
    func getExternalDFUFiles () -> [URL]! {
        var files: [URL] = []
        let documentsFolder =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        //let documentsInboxFolder = documentsFolder!.appendingPathComponent("Inbox")
        getSubFolderFiles(folder: documentsFolder!, &files)
        return files
    }
    
    private func getSubFolderFiles(folder: URL, _ fileURL: inout [URL]) {
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
            if contents.count == 0 {
                return
            }
            for item in contents  {
                if item.hasDirectoryPath {
                    getSubFolderFiles(folder: item, &fileURL)
            
                } else {
                    fileURL.append(item)
                }
            }
        } catch _ {
            
        }
    }
    
    func getDFUHelpDocuments() -> [String: AnyObject]! {
        var plistData: [String: AnyObject]!
        var propertyListForamt =  PropertyListSerialization.PropertyListFormat.xml
        let plistPath = Bundle.main.path(forResource: "DFUHelp", ofType: "plist")
        let plistXML = FileManager.default.contents(atPath: plistPath!)
        plistData = try? PropertyListSerialization.propertyList(from: plistXML!, options: .mutableContainersAndLeaves, format: &propertyListForamt) as! [String:AnyObject]
        return plistData
    }
    
    
    func saveUserFirmwareList(firmwares: UserFirmwareListPersist, completion: @escaping CallBack, session: BLESession) {
        DispatchQueue.main.async {
            let documentsUrl =  FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first
            let destinationUrl = documentsUrl!.appendingPathComponent("nRFConnect_firmwares")
            if FileManager().fileExists(atPath: destinationUrl.path) {
                self.removeFiles(fileURL: destinationUrl)
            }
            do {
                try firmwares.toJsonString().write(to: destinationUrl, atomically: true, encoding: String.Encoding.utf8)
                completion(destinationUrl, nil)
            } catch let error as NSError
            {
                completion(destinationUrl, error)
                self.logManager.addLog(FileAccessError.SaveFileFailed.getDescription(), logType: .error, object: #function, session: session)
            }
        }
    }
    
    func readUserFirmwareList(completion: CallBack, session: BLESession) -> [UserFirmwarePersist]? {
        let documentsUrl =  FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first
        let destinationUrl = documentsUrl!.appendingPathComponent("nRFConnect_firmwares")
        if FileManager().fileExists(atPath: destinationUrl.path) {
            do
            {
                let temp = try String(contentsOfFile: destinationUrl.path, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) as String
                let result = UserFirmwareListPersist(json: temp)
                if let firmwareInfo = result.firmwareList
                {
                    return firmwareInfo
                }
            }
            catch let error
            {
                completion(destinationUrl, error)
                logManager.addLog(FileAccessError.ReadFileFailed.getDescription(), logType: .error, object: #function, session: session)
            }
        }
        return nil
    }
    
    func saveAdvertiserList(advertisers: AdvertiserList) {
            let documentsUrl =  FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first
            let destinationUrl = documentsUrl!.appendingPathComponent("nRFConnect_advertisers")
            if FileManager().fileExists(atPath: destinationUrl.path) {
                self.removeFiles(fileURL: destinationUrl)
            }
            do {
                try advertisers.toJsonString().write(to: destinationUrl, atomically: true, encoding: String.Encoding.utf8)
            } catch _ as NSError
            {
            }
    }
    
    func readAdvertiserList(completion: CallBack) -> [Advertiser]? {
        let documentsUrl =  FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first
        let destinationUrl = documentsUrl!.appendingPathComponent("nRFConnect_advertisers")
        if FileManager().fileExists(atPath: destinationUrl.path) {
            do
            {
                let temp = try String(contentsOfFile: destinationUrl.path, encoding: String.Encoding.utf8) as String
                let result = AdvertiserList(json: temp)
                if let firmwareInfo = result.advertiserList
                {
                    return firmwareInfo
                }
            }
            catch let error
            {
                completion(destinationUrl, error)
            }
        }
        return nil
    }
    
    //END MARK
    
    //MARK - Log file handling
    func createLog(_ content: String, logID: String, completion: @escaping CallBack, session: BLESession) {
        DispatchQueue.main.async {
            let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let destinationUrl = documentsUrl!.appendingPathComponent(logID)
            do {
                if !FileManager().fileExists(atPath: destinationUrl.path) {
                    try content.write(to: destinationUrl, atomically: true, encoding: String.Encoding.utf8)
                    completion(destinationUrl, nil)
                } else {
                    completion(destinationUrl, FileAccessError.FileExisted)
                }
            } catch let error
            {
                completion(destinationUrl, error)
            }
        }
    }
    
    func isLogExist(fileName logID: String) -> Bool {
        var fileCreated: Bool = false
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationUrl = documentsUrl!.appendingPathComponent(logID)
        if FileManager().fileExists(atPath: destinationUrl.path) {
            fileCreated = true
        }
        return fileCreated
    }
    
    //should not read unsafe file
    private func readLog(logID: String, completion: CallBack, session: BLESession) -> String {
        var logs: String!
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationUrl = documentsUrl!.appendingPathComponent(logID)
        if FileManager().fileExists(atPath: destinationUrl.path) {
            do
            {
                logs = try String(contentsOfFile: destinationUrl.path, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            }
            catch let error
            {
                completion(destinationUrl, error)
                logManager.addLog(FileAccessError.ReadFileFailed.getDescription(), logType: .error, object: #function, session: session)
            }
        } else {
            completion(destinationUrl, FileAccessError.NoSuchFileFound)
            logManager.addLog(FileAccessError.NoSuchFileFound.getDescription(), logType: .error, object: #function, session: session)
        }
        return logs
    }
    
    func appendNewLog(newRecords: String, logID: String, completion: CallBack, session: BLESession) {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationUrl = documentsUrl!.appendingPathComponent(logID)
        if FileManager().fileExists(atPath: destinationUrl.path) {
                if let fileHandle = FileHandle(forWritingAtPath: destinationUrl.path) {
                    defer {
                        fileHandle.closeFile()
                    }
                    fileHandle.seekToEndOfFile()
                    if let buffer = newRecords.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                        fileHandle.write(buffer)
                    } else {
                        completion(destinationUrl, DataCastingError.invalidInput(input: newRecords))
                    }
                    completion(destinationUrl, nil)
                }
        } else {
            completion(destinationUrl, FileAccessError.NoSuchFileFound)
            logManager.addLog(FileAccessError.NoSuchFileFound.getDescription(), logType: .error, object: #function, session: session)
        }
    }
    
    func deleteLog() {
        
    
    }
    //END MARK
    
    func removeFiles(fileURL: URL) {
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try? FileManager.default.removeItem(at: fileURL)
        }
    }
}

extension LocalAccessManager: FileAttributeProtocol {
    func getFileNameWithoutExtension(fileURL: URL) -> String! {
        let fileFullName = fileURL.lastPathComponent as NSString
        let fileName = fileFullName.deletingPathExtension
        return String(fileName)
    }
    
    func getFullFileName(fileURL: URL) -> String! {
        let fileFullName = fileURL.lastPathComponent
        return String(fileFullName)
    }
    
    func getFileSize(fileURL: URL) -> UInt64! {
        let filePath = fileURL.path
        var fileSize : UInt64!
        let attr = try? FileManager.default.attributesOfItem(atPath: filePath)
        fileSize = attr?[FileAttributeKey.size] as! UInt64
        return fileSize
    }
    
    func getFileKind(fileURL: URL) -> DFUFileKind {
        var fileKind : DFUFileKind
        do {
            let kind = fileURL.pathExtension
            switch kind {
            case "zip" :
                fileKind = DFUFileKind.DistributionPackage
            case "hex" :
                fileKind = DFUFileKind.Binary
            case "bin" :
                fileKind = DFUFileKind.Binary
            case "dat" :
                fileKind = DFUFileKind.Dat
            default:
                fileKind = DFUFileKind.NonSupported
            }
         }
        return fileKind
    }
    
    func isFileExist(url: URL) -> Bool {
        var isFileExist: Bool = false
        if FileManager.default.fileExists(atPath: url.path){
            isFileExist = true
        }
        return isFileExist
    }
}

extension LocalAccessManager {

//    func saveAsUIdoc(file: URL, completion: @escaping CallBack) {
//        let uiDoc = UIDocument(fileURL: file)
//        uiDoc.save(to: uiDoc.fileURL, for: .forCreating) { (hasSuceed) in
//            if !hasSuceed {
//                completion(file, FileAccessError.FailedToAccessFilePath)
//            }
//        }
//    }
}

