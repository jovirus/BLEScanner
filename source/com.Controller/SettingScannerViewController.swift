//
//  SettingAboutNavigationViewController.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 11/09/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

extension SettingScannerViewController: SettingScannerTimeOutDelegate {
//    func timeOutChosen(time: String) { }
    func didTimeOutChoose(time: ScannerTimeOutEnum) {
        self.settingScannerViewModel.setTimeoutScanner(value: time)
        self.timeoutDetail.text = self.settingScannerViewModel.timeoutValue.description()
//        self.scannerSettingsTableView.reloadData()
    }
}


class SettingScannerViewController: UITableViewController {
    
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var timeoutDetail: UILabel!
    
    var settingScannerViewModel = SettingScannerViewModel()
    
    override func viewDidLoad() {
        self.settingsTableView.delegate = self
        self.settingsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timeoutDetail.text = settingScannerViewModel.timeoutValue.description()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scannerTimeoutPickerSegue" {
            let destinationVC = segue.destination as! SettingScannerTimeOutPickerView
            destinationVC.settingScannerPickerViewModel.setTimeOut(value: self.settingScannerViewModel.timeoutValue)
            destinationVC.settingScannerPickerViewModel.settingScannerTimeOutDelegate = self
        }
    }
}
