//
//  MainSWRevealViewController.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 04/07/16.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import SWRevealViewController

class MainSWRevealViewController: SWRevealViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let _ = self.rearViewController.view
    }
}
