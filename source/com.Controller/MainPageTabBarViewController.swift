//
//  MainPageTabBarViewController.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 22/05/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit
class MainPageTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        UITabBar.appearance().tintColor = UIColor.nordicBlue()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.nordicBlue()], for: .selected)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

    }
}
