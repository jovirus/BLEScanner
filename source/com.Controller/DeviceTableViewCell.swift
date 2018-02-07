//
//  DeviceTableViewCell.swift
//  FIrstAppleProject
//
//  Created by Jiajun Qiu on 24/06/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {
    
    //MARK: - Header - Icon panel
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var IconFavourite: UIImageView!
    @IBOutlet weak var IconFavouriteHeight: NSLayoutConstraint!
    @IBOutlet weak var iPadIconFavouriteHeight: NSLayoutConstraint!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var IconBackground: UIImageView!
    @IBOutlet weak var IconMiddleBackground: UIImageView!
    @IBOutlet weak var FavouriteButton: UIButton!
    @IBOutlet weak var IconFavouriteTopIconBackgroundBottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var iPadIconFavouriteTopIconBackgroundBottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var HeaderViewHeight: NSLayoutConstraint!

    
    //MARK: - Header - Info panel
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var isConnectable: UILabel!
    @IBOutlet weak var deviceSignalStrengthen: UILabel!
    @IBOutlet weak var RowExpandButton: UIButton!
    @IBOutlet weak var intervalImageView: UIImageView!
    @IBOutlet weak var intervalValueLabel: UILabel!
    
    //MARK: - Header - Connect button
    @IBOutlet weak var ConnectPeripheralButton: UIButton!

    //MARK: - Detail - value
    @IBOutlet weak var DetailView: UIView!
    @IBOutlet weak var CompleteLocalName: UILabel!
    @IBOutlet weak var TxPowerLevel: UILabel!
    @IBOutlet weak var serviceUUID: UILabel!
    @IBOutlet weak var manufacturerData: UILabel!
    @IBOutlet weak var solicitedServiceUUID: UILabel!
    @IBOutlet weak var serviceData: UILabel!
    @IBOutlet weak var OverflowServiceUUID: UILabel!
    @IBOutlet weak var DetailViewHeight: NSLayoutConstraint!

    //MARK: - Detail - label
    @IBOutlet weak var CompleteLocalNameLabel: UILabel!
    @IBOutlet weak var ManufacturerDataLabel: UILabel!
    @IBOutlet weak var TxPowerLevelLabel: UILabel!
    @IBOutlet weak var SolicitedServiceUUIDLabel: UILabel!
    @IBOutlet weak var ServiceUUIDLabel: UILabel!
    @IBOutlet weak var ServiceDataLabel: UILabel!
    @IBOutlet weak var OverflowServiceUUIDLabel: UILabel!
    
    var deviceID: String?
    static let ManufacturerDataButtonRestorationKey = "Manufacturer Data"
    static let ServiceDataButtonRestorationKey = "Service Data"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func FavouriteButtonPressed(_ sender: AnyObject) {
    }
    
    
    @IBAction func ConnectPeripheralButtonPressed(_ sender: UIButton) {
        
    }
    
}
