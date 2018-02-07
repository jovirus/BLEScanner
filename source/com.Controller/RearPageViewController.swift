//
//  RearPageViewController.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 22/04/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import UIKit

protocol RearViewControllerStatusDelegate {
    func rearPageWillAppear(_ pageType: RearPageViewEnum)
    func rearPageWillDisappear(_ pageType: RearPageViewEnum)
}

class RearPageViewController: UIViewController
{
    @IBOutlet weak var containerHeaderLabel: UILabel!
    @IBOutlet weak var logContainerView: UIView!
    @IBOutlet weak var AboutPageContainerView: UIView!
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var HeaderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ChartContainerView: UIView!
    @IBOutlet weak var chartContainerViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var logContainerViewTrailing: NSLayoutConstraint!
    
    var rearViewControllerStatusDelegate: RearViewControllerStatusDelegate!
    var rearPageViewModel = RearPageViewModel()
    
    override func viewDidLoad() {
        revealViewController().rearViewRevealOverdraw = 0.0
        revealViewController().rearViewRevealWidth = UIHelper.screenWidth*0.85
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let parentVC = self.revealViewController() else { return }
        guard (parentVC.frontViewController as! MainPageTabBarViewController).selectedViewController is ScannerNavigationViewController else { return }
        let nav = (parentVC.frontViewController as! MainPageTabBarViewController).selectedViewController as! ScannerNavigationViewController
        guard let topVC = nav.childViewControllers.last else { return }
        self.rearPageViewModel.setTopViewController(vc: topVC)
        if topVC.isKind(of: ScanningDevicePageViewController.self) {
            let vc = topVC as! ScanningDevicePageViewController
            if vc.pushButtonIndex == 0 {
                //not in used any more, about page is individual
                rearPageViewModel.currentViewIndex = .aboutView
//                aboutPageContainerTrailing.constant = UIHelper.screenWidth*0.158
            } else if vc.pushButtonIndex == 1 {
                // chart view site
                 rearPageViewModel.currentViewIndex = .graphView
                 chartContainerViewTrailing.constant = 0
            }
        } else {
            rearPageViewModel.currentViewIndex = .logView
            logContainerViewTrailing.constant = 0
        }
        rearViewControllerStatusDelegate?.rearPageWillAppear(rearPageViewModel.currentViewIndex)
        loadRearView(rearPageViewModel.currentViewIndex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        rearViewControllerStatusDelegate?.rearPageWillDisappear(rearPageViewModel.currentViewIndex)
    }
    
    func loadRearView(_ viewIndex: RearPageViewEnum) {
        HeaderView.backgroundColor = UIColor.nordicGray()
        containerHeaderLabel.backgroundColor = UIColor.nordicGray()
        switch viewIndex {
        case .logView:
            UIView.animate(withDuration: 0.1, animations: {
                self.logContainerView.alpha = 1
                self.AboutPageContainerView.alpha = 0
                self.ChartContainerView.alpha = 0
                self.containerHeaderLabel.text = "Log"
            })
        case .graphView:
            UIView.animate(withDuration: 0.1, animations: {
                self.ChartContainerView.alpha = 1
                self.logContainerView.alpha = 0
                self.AboutPageContainerView.alpha = 0
                self.containerHeaderLabel.text = "RSSI"
                self.prepareForRSSIChart()
            })
        case .aboutView:
            UIView.animate(withDuration: 0.1, animations: {
                self.AboutPageContainerView.alpha = 1
                self.logContainerView.alpha = 0
                self.ChartContainerView.alpha = 0
                self.containerHeaderLabel.text = "About"
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChartView" {
            self.rearPageViewModel.setGraphViewController(viewController: segue.destination as! RSSIChartViewController)
        } else if segue.identifier == "LogView" {
            self.rearPageViewModel.setLogViewController(viewController: segue.destination as! LogViewController)
        }
    }
    
    func prepareForRSSIChart () {
        guard self.rearPageViewModel.currentViewIndex == .graphView else {
            return
        }
        self.rearPageViewModel.graphViewController.rssiChartViewModel.rssiChartModel.initializeChartModel(viewModel: ((self.rearPageViewModel.topViewController) as! ScanningDevicePageViewController).scanningDevicePageViewModel)
    }
}
