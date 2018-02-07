//
//  AppInformationViewController.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 24/06/16.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

class AppInformationViewController: UIViewController {
    
    @IBOutlet weak var tutorial_iconImageView: UIImageView!
    
    @IBOutlet weak var tutorialIcon_width: NSLayoutConstraint!
    @IBOutlet weak var tutorialIcon_height: NSLayoutConstraint!
    @IBOutlet weak var nameTutorialLabel: UILabel!
    @IBOutlet weak var OkButton: UIButton!
    @IBOutlet weak var tutorialNordicIcon_width: NSLayoutConstraint!
    @IBOutlet weak var tutorialNordicIcon_height: NSLayoutConstraint!
    @IBOutlet weak var ContentLabel: UILabel!
    
    override func viewDidLoad() {
        let widthForIcon = UIHelper.screenWidth*0.3
        let widthForTitle = UIHelper.screenWidth*0.065
//      tutorial_iconImageView.frame = CGRectMake(220, 101, 30, 30)
        tutorialIcon_width.constant = widthForIcon
        tutorialIcon_height.constant = widthForIcon
        nameTutorialLabel.font = UIFont.systemFont(ofSize: widthForTitle)
        nameTutorialLabel.adjustsFontSizeToFitWidth = true
        addContent()
    }
    
    @IBOutlet weak var dismissInformationPages: UIButton!
    
    @IBAction func dismissInformationButtonClicked(_ sender: AnyObject) {
        changeSWFrontVC()
    }
    
    fileprivate func changeSWFrontVC() {
        revealViewController().setFront(storyboard?.instantiateViewController(withIdentifier: "MainPageTabBarViewController"), animated: true)
    }
    
    fileprivate func addContent() {
        let header = "nRF Connect(iOS) " + AppInfo.version + " includes bug fixes and new features. This updates:" + Symbols.newRow
        let line1 = Symbols.whiteBullet + " Supports micro:bit" + Symbols.newRow
        let line2 = Symbols.whiteBullet + " Adds option to disable rename feature in bootloader mode" + Symbols.newRow
        let line3 = Symbols.whiteBullet + " Fixes an issue on filter" + Symbols.newRow
        let line4 = Symbols.whiteBullet + " Fixes an issue when parsing manufacture advertisement data" + Symbols.newRow
        let line5 = Symbols.whiteBullet + " Fixes an issue when parsing Eddystone advertisement data" + Symbols.newRow
        let line6 = Symbols.whiteBullet + " Updates UI for iPhoneX " + Symbols.newRow
        self.ContentLabel.text = header + line1 + line2 + line3 + line4 + line5 + line6
    }
}
