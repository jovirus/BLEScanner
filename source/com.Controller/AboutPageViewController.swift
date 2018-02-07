//
//  SettingPageTableViewController.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 02/10/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class AboutPageViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var mailIcon: UIImageView!
    @IBOutlet weak var AboutText: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var linkedinButton: UIButton!
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var gitHubButton: UIButton!
    @IBOutlet weak var nordicwebLinkButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    
    @IBOutlet weak var nordic_logo_height: NSLayoutConstraint!
    @IBOutlet weak var Feedback_view_to_Social_button_view_constrain: NSLayoutConstraint!
    @IBOutlet weak var versionNumber: UILabel!
    
    @IBAction func socialMediaButtonClicked(_ sender: UIButton) {
        let tag = sender.tag
        
        switch tag
        {
            case 0:
                UIApplication.shared.openURL(URL(string:"https://www.facebook.com/nordicsemiconductor?fref=ts")!);
                break;
            case 1:
                UIApplication.shared.openURL(URL(string:"https://twitter.com/NordicTweets")!);
                break;
            case 2:
                UIApplication.shared.openURL(URL(string:"https://www.linkedin.com/company/nordic-semiconductor-asa")!);
                break;
            case 3:
                UIApplication.shared.openURL(URL(string:"https://www.youtube.com/user/NordicSemi")!);
                break;
            case 4:
                UIApplication.shared.openURL(URL(string:"https://devzone.nordicsemi.com/questions/")!);
                break;
            case 5:
                UIApplication.shared.openURL(URL(string:"https://github.com/NordicSemiconductor/IOS-nRF-Connect")!);
                break;
            default:
                break;
        }
    }
    
    @IBAction func nordicwebLinkButton(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string:"http://www.nordicsemi.com/")!);
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationBar?.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.nordic_logo_height.constant = UIHelper.screenHeight*0.15
        self.Feedback_view_to_Social_button_view_constrain.constant = UIHelper.screenHeight*0.05
    }
    
    override func viewDidLoad() {
        setAboutText()
        setVersionNumber()
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func setVersionNumber() {
        let version = "Version " + AppInfo.version
        self.versionNumber.text = version
    }
    
    func setAboutText()
    {
        let htmlString: String = "<style type= &quot; text/css &quot;>p.serif { font-family: &quot; Times New Roman &quot;, Times, serif;} </style> <p class= &quot; serif &quot;><font size=&quot; 3 &quot; ><strong>nRF Connect </strong>is a powerful generic tool that allows you to scan for Bluetooth Smart devices and communicate with them. It supports a number of Bluetooth SIG adopted profiles, as well as Device Firmware Update profile (DFU) from Nordic Semiconductor.</font></p><div align= &quot; right &quot;>"
        let attrStr = try! NSMutableAttributedString(
            data: htmlString.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        let aboutTextFont = UIFont.boldSystemFont(ofSize: 14)
        attrStr.convertFontTo(aboutTextFont)
        self.AboutText.attributedText = attrStr
    }
    
    @IBAction func sendEmailButtonClicked(_ sender: UIButton) {
        let mailComposeViewController = composeMail()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func composeMail() ->MFMailComposeViewController
    {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["mag@nordicsemi.no"])
        mailComposerVC.setSubject("nRF Connect(iOS)Feedback")
        mailComposerVC.setMessageBody("", isHTML: false)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Suggestion", message: "Send questions on gitHub?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            UIApplication.shared.openURL(URL(string: "https://github.com/NordicSemiconductor/IOS-nRF-Connect/issues")!);
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
           
        }
        sendMailErrorAlert.addAction(okAction)
        sendMailErrorAlert.addAction(cancelAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
            switch result.rawValue {
                case MFMailComposeResult.cancelled.rawValue:
                    print("Mail cancelled")
                case MFMailComposeResult.saved.rawValue:
                    print("Mail saved")
                case MFMailComposeResult.sent.rawValue:
                    print("Mail sent")
                case MFMailComposeResult.failed.rawValue:
                    print("Mail sent failure: %@", [error?.localizedDescription])
                default:
                    break
                }
            self.dismiss(animated: true, completion: nil)
    }
}
