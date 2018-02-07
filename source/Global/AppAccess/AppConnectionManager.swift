//
//  AppConnectionManager.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 09/03/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//
import Foundation
import UIKit

protocol AppConnectionManagerDelegate {
    
    func reachabilityStatusChanged(_ isInternetConnected: Bool)
}

internal class AppConnectionManager: NSObject {
    var reachabilityStatusChangeDelegate: AppConnectionManagerDelegate?
    fileprivate var _useClosures:Bool = false
    fileprivate var reachability: Reachability?
    fileprivate var _isReachable:Bool = false
    
    var isReachable:Bool {
        get {return _isReachable}
    }
    
    // Create a shared instance of AppManager
    final class var instance : AppConnectionManager {
        struct Static {
            static var sharedInstance : AppConnectionManager?
        }
        if !(Static.sharedInstance != nil) {
            Static.sharedInstance = AppConnectionManager()
            
        }
        return Static.sharedInstance!
    }
    // Reachability Methods--------------------------------------------------------------------------------//
    func initRechabilityMonitor() {
        print("initialize reachability...")
        self.reachability = Reachability()
        if (_useClosures) {
            reachability?.whenReachable = { reachability in
                DispatchQueue.main.async {
                    if reachability.isReachableViaWiFi {
                        print("Reachable via WiFi")
                    } else {
                        print("Reachable via Cellular")
                    }
                }
                self.notifyReachability(reachability)
            }
            reachability?.whenUnreachable = { reachability in
                DispatchQueue.main.async {
                    print("Not reachable")
                }
                self.notifyReachability(reachability)
            }
        } else {
            self.notifyReachability(reachability!)
        }
        do {
            try reachability?.startNotifier()
        } catch {
            print("unable to start notifier")
            return
        }
    }
    
    fileprivate func notifyReachability(_ reachability:Reachability) {
        isReachable(reachability)
        NotificationCenter.default.addObserver(self, selector: #selector(AppConnectionManager.reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    fileprivate func isReachable(_ reachability:Reachability)
    {
        if reachability.isReachable {
            self._isReachable = true
        } else {
            self._isReachable = false
        }
    }
    
    @objc func reachabilityChanged(_ note: Notification) {
        self.reachability = note.object as? Reachability
        if let value = self.reachability
        {
            isReachable(value)
            self.reachabilityStatusChangeDelegate?.reachabilityStatusChanged(isReachable)
        }
    }
    
    deinit {
        reachability?.stopNotifier()
        if (!_useClosures) {
            NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        }
    }
}
