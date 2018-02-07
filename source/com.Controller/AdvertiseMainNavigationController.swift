//
//  AdvertiseMainNavigationController.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 13/06/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit
class AdvertiseMainNavigationController: UINavigationController {
    
    //var navigationViewModel = AdvertiseMainNavigationViewModel()
    
    override func viewDidAppear(_ animated: Bool) {
        revealViewController().panGestureRecognizer().isEnabled = false
    }
}
