//
//  CheckBox.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 11/03/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
import UIKit
class CheckBox: UIButton {
    let checkedImage = UIImage(named: "ic_radio_button_checked_blue")! as UIImage
    let uncheckedImage = UIImage(named: "ic_radio_button_unchecked_blue")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControlState())
            } else {
                self.setImage(uncheckedImage, for: UIControlState())
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(CheckBox.buttonClicked(_:)), for: UIControlEvents.touchUpInside)
        //self.isChecked = false
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        if sender == self {
            if isChecked == true {
                isChecked = false
            } else {
                isChecked = true
            }
        }
    }
}
