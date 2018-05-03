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
        let line1 = Symbols.whiteBullet + " Improve performance for scanner" + Symbols.newRow
        let line2 = Symbols.whiteBullet + " Add support for experimental buttonless DFU"  + Symbols.newRow
        let line3 = Symbols.whiteBullet + " Fix issue when observe broadcasting interval" + Symbols.newRow
        self.ContentLabel.text = header + line1 + line2 + line3
    }
}
