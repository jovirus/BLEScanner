//
//  ChangeDataViewPopoverViewController.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 11/03/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
import UIKit

public enum AdvertisementDataForm : Int
{
    case notAvailable = 0
    case beaconData = 1
    case manufacturerData4_1 = 2
    case manufacturerDataBytes = 3
    case eddystone = 4
    case serviceDataBytes = 5
}

public protocol ChangeDataViewPopoverDelegate {
    func userChosenManufacturerDataFormatReady(_ userChoice: AdvertisementDataForm, deviceID: String, atRow: Int)
}

open class ChangeDataViewPopoverViewController : UIViewController {
    
    
    @IBOutlet weak var BeaconDataLabel: UILabel!
    @IBOutlet weak var BeaconDataCheckButton: CheckBox!
    @IBOutlet weak var BeaconDataCheckButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var BeaconDataLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var ManufacturerData4_1Label: UILabel!
    @IBOutlet weak var ManufacturerData4_1CheckButton: CheckBox!
    @IBOutlet weak var ManufacturerData4_1CheckButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var ManufacturerData4_1LabelHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var ManufacturerDataLabel: UILabel!
    @IBOutlet weak var ManufacturerDataCheckButton: CheckBox!
    @IBOutlet weak var ManufacturerDataCheckButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var ManufacturerDataLabelHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var EddystoneEIDLabel: UILabel!
    @IBOutlet weak var EddystoneEIDCheckButton: CheckBox!
    @IBOutlet weak var EddystoneEIDCheckButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var EddystoneEIDLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var ServiceDataLabel: UILabel!
    @IBOutlet weak var ServiceDataCheckButton: CheckBox!
    
    @IBOutlet weak var ServiceDataCheckButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var ServiceDataLabelHeight: NSLayoutConstraint!
    
    
    static let instance = WriteValuePopoverViewController()
    
    let sizeForServiceDatView = CGSize(width: 300, height: 130)
    let sizeForManufacturerDatView = CGSize(width: 350, height: 180)

    var deviceID: String?
    var atRow: Int?

    var changeDataViewPopoverDelegate: ChangeDataViewPopoverDelegate?
    
    var currentFormat = AdvertisementDataForm.notAvailable
    
    var chosenLabel: UILabel?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        initializeViews()
    }
    
    func initializeViews()
    {
        guard let label = chosenLabel else {
            return
        }
        if label.text == DeviceTableViewCell.ManufacturerDataButtonRestorationKey
        {
            // disale service data choices
            hideServiceDataButtons()
            initialManufacturerDataCheckButtons()
            if let chosenButton = getManufacturerDataChosenButton(currentFormat)
            {
                chosenButton.isChecked = true
            }
        } else if label.text == DeviceTableViewCell.ServiceDataButtonRestorationKey
        {
            hideManufacturerDataButtons()
            initialServiceDataCheckButtons()
            if let chosenButton = getServiceDataChosenButton(currentFormat)
            {
                chosenButton.isChecked = true
            }
        }
        setUpAlignment()
    }
    
    func setUpAlignment() {
        BeaconDataCheckButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        ManufacturerData4_1CheckButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        ManufacturerDataCheckButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        EddystoneEIDCheckButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        ServiceDataCheckButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
    }
    
    func getManufacturerDataChosenButton(_ choice: AdvertisementDataForm) -> CheckBox!
    {
        var chosenButton: CheckBox?
        switch choice
        {
            case AdvertisementDataForm.beaconData:
                chosenButton = BeaconDataCheckButton
                break
            case AdvertisementDataForm.manufacturerData4_1:
                chosenButton = ManufacturerData4_1CheckButton
                break
            case AdvertisementDataForm.manufacturerDataBytes:
                chosenButton = ManufacturerDataCheckButton
                break
            case AdvertisementDataForm.notAvailable:
                chosenButton = ManufacturerDataCheckButton
            default:
                break
        }
        return chosenButton
    }
    
    func getServiceDataChosenButton(_ choice: AdvertisementDataForm) -> CheckBox!
    {
        var chosenButton: CheckBox?
        switch choice
            {
            case AdvertisementDataForm.eddystone:
                chosenButton = EddystoneEIDCheckButton
                break
            case AdvertisementDataForm.serviceDataBytes:
                chosenButton = ServiceDataCheckButton
                break
            case AdvertisementDataForm.notAvailable:
                chosenButton = ServiceDataCheckButton
            default:
                break
        }
        return chosenButton
    }
    
    func hideServiceDataButtons()
    {
        EddystoneEIDCheckButtonHeight.constant = 0
        EddystoneEIDLabelHeight.constant = 0
        
        ServiceDataCheckButtonHeight.constant = 0
        ServiceDataLabelHeight.constant = 0
        
        BeaconDataCheckButtonHeight.constant = 38
        BeaconDataLabelHeight.constant = 38
        
        ManufacturerData4_1CheckButtonHeight.constant = 38
        ManufacturerData4_1LabelHeight.constant = 38
        
        ManufacturerDataCheckButtonHeight.constant = 38
        ManufacturerDataLabelHeight.constant = 38
    }
    
    func hideManufacturerDataButtons()
    {
        BeaconDataCheckButtonHeight.constant = 0
        BeaconDataLabelHeight.constant = 0
        
        ManufacturerData4_1CheckButtonHeight.constant = 0
        ManufacturerData4_1LabelHeight.constant = 0
        
        ManufacturerDataCheckButtonHeight.constant = 0
        ManufacturerDataLabelHeight.constant = 0
        
        EddystoneEIDCheckButtonHeight.constant = 38
        EddystoneEIDLabelHeight.constant = 38
        
        ServiceDataCheckButtonHeight.constant = 38
        ServiceDataLabelHeight.constant = 38
    }
    
    func setUserChoiceValue(_ choice: AdvertisementDataForm)
    {
        switch choice
        {
            case AdvertisementDataForm.beaconData:
                currentFormat = AdvertisementDataForm.beaconData
                break
            case AdvertisementDataForm.manufacturerData4_1:
                currentFormat = AdvertisementDataForm.manufacturerData4_1
                break
            case AdvertisementDataForm.manufacturerDataBytes:
                currentFormat = AdvertisementDataForm.manufacturerDataBytes
                break
            case AdvertisementDataForm.eddystone:
                currentFormat = AdvertisementDataForm.eddystone
                break
            case AdvertisementDataForm.serviceDataBytes:
                currentFormat = AdvertisementDataForm.serviceDataBytes
                break
            default:
                break
        }
    }
    
    func initialManufacturerDataCheckButtons()
    {
        BeaconDataCheckButton.isChecked = false
        ManufacturerData4_1CheckButton.isChecked = false
        ManufacturerDataCheckButton.isChecked = false
    }
    
    func initialServiceDataCheckButtons()
    {
        ServiceDataCheckButton.isChecked = false
        EddystoneEIDCheckButton.isChecked = false
    }
    
    @IBAction func checkButtonClicked(_ sender: CheckBox) {
        self.dismiss(animated: false) {
            self.initialManufacturerDataCheckButtons()
            if let newValue = AdvertisementDataForm(rawValue: sender.tag)
            {
                self.setUserChoiceValue(newValue)
            }
            self.changeDataViewPopoverDelegate!.userChosenManufacturerDataFormatReady(self.currentFormat, deviceID: self.deviceID!, atRow: self.atRow!)
        }
    }
    
    func dismissPopover()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override open func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        dismissPopover()
    }
}
