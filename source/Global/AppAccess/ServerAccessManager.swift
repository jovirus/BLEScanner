//
//  WebHandler.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 04/03/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
import SystemConfiguration

internal class ServerAccessManager: AppConnectionManagerDelegate
{
    internal typealias callBack = (_ path: URL, _ error: Error?) -> Void
    static var instance = ServerAccessManager()
    
    fileprivate init()
    {
        AppConnectionManager.instance.reachabilityStatusChangeDelegate = self
    }
    
    func reachabilityStatusChanged(_ isInternetConnected: Bool)
    {
        if isInternetConnected
        {
            AppInitializer.installCompanyInfo()
        }
    }
    
    func loadFileSync(_ url: URL, completion: callBack) {
        let documentsUrl =  FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first
        let destinationUrl = documentsUrl!.appendingPathComponent(url.lastPathComponent)
        if FileManager().fileExists(atPath: destinationUrl.path) {
            print("file already exists [\(destinationUrl.path)]")
            completion(destinationUrl, FileAccessError.FileExisted)
        } else if let dataFromURL = try? Data(contentsOf: url){
            if (try? dataFromURL.write(to: destinationUrl, options: [.atomic])) != nil {
                print("file saved [\(destinationUrl.path)]")
                completion(destinationUrl, nil)
            } else {
                print("error saving file")
                completion(destinationUrl, FileAccessError.SaveFileFailed)
            }
        } else {
            completion(destinationUrl, FileAccessError.FileDownloadingFailed)
        }
    }

    func loadFileAsync(_ url: URL, completion: @escaping callBack) {
        let documentsUrl =  FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first
        let destinationUrl = documentsUrl!.appendingPathComponent(url.lastPathComponent)
        if FileManager().fileExists(atPath: destinationUrl.path) {
            completion(destinationUrl, FileAccessError.FileExisted)
        } else {
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
                if (error == nil) {
                    if let response = response as? HTTPURLResponse {
                        print("response=\(response)")
                        if response.statusCode == 200 && data != nil{
                            do{
                                let temp = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                                try temp?.write(toFile: destinationUrl.path, atomically: false, encoding: String.Encoding.utf8)
                                completion(destinationUrl, nil)
                            } catch {
                                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                                completion(destinationUrl, error)
                            }
                        }
                      }
                    }
                else {
                    completion(destinationUrl, error as NSError?)
                }
            })
            task.resume()
        }
    }
}
