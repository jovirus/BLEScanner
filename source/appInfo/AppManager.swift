//
//  AppManager.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 22/06/16.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation

open class AppManager {
    
    static var instance = AppManager()
    fileprivate(set) var shouldShowTutorialPage: Bool = false
    
//    @available(*, deprecated: 1.8, message: "use updateUserDefault() instead")
//    func updateUserInfo() {
//        var userInfoList: UserInfoList!
//        userInfoList = LocalAccessManager.instance.readUserInfo { (path, error) in
//            if error != nil {
//                NSLog((error?.localizedDescription)!)
//            }
//        }
//
//        if userInfoList == nil {
//            let persistent = UserInfoList()
//            persistent.listOfUserInfo.append(UserInfo())
//            LocalAccessManager.instance.createUserInfo(userInfo: persistent, completion: { (path, error) in
//                if error != nil {
//                    NSLog((error?.localizedDescription)!)
//                }
//            })
//            shouldShowTutorialPage = true
//        } else if userInfoList != nil && userInfoList.listOfUserInfo.count == 0 {
//            // can not read the file properly
//            userInfoList.listOfUserInfo.append(UserInfo())
//            LocalAccessManager.instance.createUserInfo(userInfo: userInfoList, completion: { (path, error) in
//                if error != nil {
//                    NSLog((error?.localizedDescription)!)
//                }
//            })
//            shouldShowTutorialPage = true
//        } else if userInfoList != nil && userInfoList.listOfUserInfo.count > 0
//        {
//            // the user info file read properly 
//            let newInfo = UserInfo()
//            let lastUse = userInfoList.listOfUserInfo.last
//            if UserInfo.isNewVersion(lastUse: lastUse!, newInfo: newInfo) {
//                self.shouldShowTutorialPage = true
//            }
//            userInfoList.listOfUserInfo.append(newInfo)
//            LocalAccessManager.instance.createUserInfo(userInfo: userInfoList, completion: { (path, error) in
//                if error != nil {
//                    NSLog((error?.localizedDescription)!)
//                }
//            })
//        }
//    }
    
    func updateUserDefault() {
        if let result = UserInfo.getUserDefaults() {
            let newInfo = UserInfo()
            if UserInfo.isNewVersion(lastUse: result, newInfo: newInfo) {
                self.shouldShowTutorialPage = true
                newInfo.saveUserDefaults()
            }
        } else {
            UserInfo().saveUserDefaults()
        }
    }
}
