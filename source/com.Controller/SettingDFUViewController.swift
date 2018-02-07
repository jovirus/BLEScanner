//
//  SettingDFUViewController.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 28/11/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

class SettingDFUViewController: UITableViewController {
    
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var alternativeNameSwitch: UISwitch!
    
    var dfuViewModel = SettingDFUViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        alternativeNameSwitch.isOn = dfuViewModel.enableAlternativeName
    }
    
    @IBAction func alternativeNameSwitchChanged(_ sender: UISwitch) {
        dfuViewModel.shouldUseAlternativeName(sender.isOn)
        dfuViewModel.saveSettings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dfuViewModel.saveSettings()
    }
}
