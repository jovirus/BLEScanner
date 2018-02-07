//
//  GeneralMainNavigationController.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 14/09/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

class GeneralMainNavigationController: UINavigationController {
    override func viewDidAppear(_ animated: Bool) {
        revealViewController().panGestureRecognizer().isEnabled = false
    }
}
