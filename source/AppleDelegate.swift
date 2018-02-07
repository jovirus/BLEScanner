//
//  AppleDelegate.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 17/07/15.
//  Copyright (c) 2015 Jiajun Qiu. All rights reserved.
//
//
//  AppDelegate.swift
//  FIrstAppleProject
//
//  Created by Jiajun Qiu on 18/06/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import UIKit
import MessageUI

protocol AppStatusTransitionDelegate {
    func applicationDidEnterBackground(_ application: UIApplication)
    func applicationDidBecomeActive(_ application: UIApplication)
    func applicationWillTerminate(_ application: UIApplication)
//    func appDidFinishLaunching(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    fileprivate(set) var appStatusDelegate: [AppStatusTransitionDelegate] = []
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        //installation for crash report
        
//        UINavigationBar.appearance().backgroundColor = UIColor.blue
        UINavigationBar.appearance().tintColor = UIColor.white
        UIApplication.shared.statusBarStyle = .lightContent
        
        //download nessessary files
        AppConnectionManager.instance.initRechabilityMonitor()
        AppInitializer.installCompanyInfo()
        //update userInfo
        AppManager.instance.updateUserDefault()
        AppInitializer.installDFUHelpDoc()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialVC = mainStoryboard.instantiateViewController(withIdentifier: "SWRevealViewController")
        self.window?.rootViewController = initialVC
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        print("app will resign active")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("did enter background now")

//        let result = CBPeripheralManager.init(delegate: self.peripheralManager, queue: DispatchQueue.main, options: [CBPeripheralManagerOptionRestoreIdentifierKey: "#nRFConnect_Advertiser"])
//        print(result.isAdvertising)
        appStatusDelegate.forEach { (viewController) in
            viewController.applicationDidEnterBackground(application)
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("app will into foreground")
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("app did become active")
        appStatusDelegate.forEach { (viewController) in
            viewController.applicationDidBecomeActive(application)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        // Called when app in foreground and killed by user 
        // Non called when in background killed by user
        print("app will terminate")
        appStatusDelegate.forEach { (viewController) in
            viewController.applicationWillTerminate(application)
        }
    }
}

extension AppDelegate {
    func registerViewController(vc: AppStatusTransitionDelegate) {
        self.appStatusDelegate.append(vc)
    }
}

