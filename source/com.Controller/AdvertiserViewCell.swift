//
//  AdvertiserViewCell.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 12/06/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

class AdvertiserViewCell: UITableViewCell {
    
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var localName: UILabel!
    @IBOutlet weak var serviceUUID: UILabel!
    @IBOutlet weak var advertiserSwitchButton: UISwitch!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var detailView: UIView!
    
    
}
