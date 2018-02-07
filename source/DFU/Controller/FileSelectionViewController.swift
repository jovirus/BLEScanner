//
//  FileSelectionViewController.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 30/11/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

class FileSelectionViewController: UITabBarController {
    
    override func viewDidLoad() {
        UITabBar.appearance().tintColor = UIColor.nordicBlue()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.nordicBlue()], for: .selected)
    }
}
