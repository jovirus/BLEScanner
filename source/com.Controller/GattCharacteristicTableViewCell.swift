//
//  GattCharacteristicTableViewCell.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 14/09/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import UIKit

class GattCharacteristicTableViewCell : UITableViewCell{
    @IBOutlet weak var CharacteristicName: UILabel!
    @IBOutlet weak var CharacteristicUUID: UILabel!
    @IBOutlet weak var CharacteristicProperty: UILabel!
    @IBOutlet weak var ReadCharacteristicButton: UIButton!
    @IBOutlet weak var characteristicValueLabel: UILabel!
    @IBOutlet weak var WriteCharacteristicButton: UIButton!
    @IBOutlet weak var HasDescriptorLabel: UILabel!
    @IBOutlet weak var StartNotificationButton: UIButton!
    @IBOutlet weak var StartIndicationButton: UIButton!
    
    @IBOutlet weak var CharacteristicViewCell: UIView!
    @IBOutlet weak var StartIndicationButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var StartNotificationButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var WriteCharacteristicButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var ReadCharacteristicButtonWidth: NSLayoutConstraint!
}