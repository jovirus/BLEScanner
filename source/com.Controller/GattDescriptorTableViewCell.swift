//
//  GattDescriptorTableViewCell.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 28/09/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import UIKit
class GattDescriptorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var DescriptorName: UILabel!
    @IBOutlet weak var DescriptorUuid: UILabel!
    @IBOutlet weak var DescriptorValue: UILabel!
    @IBOutlet weak var ReadValueButton: UIButton!
    @IBOutlet weak var SendValueButton: UIButton!
    @IBOutlet weak var ReadValueButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var WriteValueButtonWidth: NSLayoutConstraint!
}