//
//  DeviceDetailTableView.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 09/09/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import UIKit

class GattServiceTableViewCell: UITableViewCell
{
    let imageUIViewWidthConstrainDefault = CGFloat(44)
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var uuid: UILabel!
    @IBOutlet weak var primary: UILabel!
    @IBOutlet weak var DFUViewButton: UIButton!
    @IBOutlet weak var imageUIViewWidthConstrain: NSLayoutConstraint!
    @IBOutlet weak var dfuButtonBackgroundView: UIView!
    
    func getGattServiceName(_ gattServiceUuid: String) ->String? {
        let result = GattServiceUUID.gattServiceUuids[gattServiceUuid]
        guard let gattServiceUuid = result else {
            return nil
        }
        return gattServiceUuid.GattName
    }
}
