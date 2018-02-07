//
//  LogViewController.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 13/04/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
import UIKit

extension LogViewController: LogActivityNotificationDelegate {
    //MARK  Call Back handles
    func didActivitiesAllDelete(session: Session) {
        
    }
    
    func didActivityAdd(activity: Log, session: Session) {
        self.logTableViewModel.setNewRecord(log: activity)
        if self.logTableViewModel.chosenUpdateMode == .manually {
            showMessageBar()
        } else if self.logTableViewModel.chosenUpdateMode == .automaticly {
            hideMessageBar()
//            guard self.logTableViewModel.performAutoUpdate() else {
//                return
//            }
            self.logTableViewModel.performAutoUpdate(completion: { (true) in
                self.insertRows(fromIndex: self.logTableViewModel.viewRecords.count-1)
            })
        }
    }
    
    fileprivate func insertRows(fromIndex: Int) {
        self.logTableView.beginUpdates()
        self.logTableView.insertRows(at: [IndexPath.init(row: fromIndex, section: 0)], with: .automatic)
        self.logTableView.endUpdates()
        self.scrollToLatest()
        self.logTableViewModel.updateComplete()
    }
    
//    fileprivate func isLogVCOnTop() -> Bool {
//        if self.revealViewController().frontViewPosition == .right && (self.revealViewController().rearViewController as! RearPageViewController).rearPageViewModel.currentViewIndex == .logView {
//            return true
//        } else {
//            return false
//        }
//    }
}

extension LogViewController: DropdownListViewControllerDelegate {
    func userChosenLogLevel(_ logLevel: LogType!) {
        self.logTableViewModel.userFilter = logLevel
        guard logLevel != nil else {
            self.logTableViewModel.setUpdatedMode(updateMode: .manually)
            return
        }
        self.logTableViewModel.setUpdatedMode(updateMode: .filterMode)
        hideMessageBar()
        self.logTableViewModel.getFilteredLog { (true) in
            self.logTableView.reloadData()
        }
    }
}

class LogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var logTableView: UITableView!
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var actionButtonLeadingConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var FilterButtom: UIButton!
    @IBOutlet weak var FilterButtonTrailingConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var ToolbarViewTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var updateButtonHeight: NSLayoutConstraint!
    
    var logTableViewModel = LogTableViewModel()
    var dropdownListViewController: DropdownListViewController!
    var refreshControl : UIRefreshControl!
    
    var logManager = LogManager.instance
    
    override func viewDidLoad() {
        logTableView.dataSource = self
        logTableView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        initializePopoverController()
        logTableView.separatorStyle = .none
        setDelegates()
        hideMessageBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        logTableView.rowHeight = UITableViewAutomaticDimension
        logTableView.estimatedRowHeight = 23
        setToolbarConstrains()
        setDelegates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.logTableViewModel.performAutoUpdate { (true) in
//            
//        }
    }
    
    fileprivate func hideMessageBar() {
        DispatchQueue.main.async {
            self.updateButton.isHidden = true
            self.updateButtonHeight.constant = 0
        }
    }
    
    fileprivate func showMessageBar() {
        DispatchQueue.main.async {
            self.updateButtonHeight.constant = 40
            self.updateButton.isHidden = false
            self.updateButton.layer.cornerRadius = 0.5*self.updateButton.bounds.size.width
            self.updateButton.clipsToBounds = true
        }
    }
    
    func setDelegates()
    {
        self.logManager.newActivityNotificationDelegate = self
    }
    
    func setToolbarConstrains()
    {
        actionButtonLeadingConstrain.constant = UIHelper.screenWidth * 0.13
        FilterButtonTrailingConstrain.constant = UIHelper.screenWidth * 0.13
        ToolbarViewTrailing.constant = 0
    }
    
    func getIndexPath(_ cellIndex: Int) ->IndexPath
    {
        let indexPath = IndexPath(row: cellIndex, section: 0)
        return indexPath
    }
    
    func initializePopoverController()
    {
        self.dropdownListViewController = self.storyboard!.instantiateViewController(withIdentifier: "DropdownListViewController") as? DropdownListViewController
        if let dropdownListViewController = self.dropdownListViewController
        {
            dropdownListViewController.dropdownListViewControllerDelegate = self
        }
    }
    
    func addRefreshControl()
    {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(LogViewController.invalidateLog), for: UIControlEvents.valueChanged)
        self.logTableView.addSubview(refreshControl)
    }
    
    
    @IBAction func updateButtonPressed(_ sender: UIButton) {
        guard self.logTableViewModel.performManualUpdate() else {
            return
        }
        logTableView.reloadData() {
            self.logTableViewModel.updateComplete()
            self.hideMessageBar()
            self.scrollToLatest()
        }
    }
    
    @IBAction func ActionButtonClicked(_ sender: UIButton) {
        if let records = self.logManager.getAllRecords(session: self.logTableViewModel.session) {
            _ = self.logManager.saveLog(content: records, session: self.logTableViewModel.session)
            let objectsToShare = [records]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            if AppInfo.deviceModel == .pad {
                activityVC.popoverPresentationController?.sourceView = sender
            }
            self.present(activityVC, animated: true, completion: nil)
        } else {
            self.logManager.addLog("No activity to show", logType: .info, object: #function, session: self.logTableViewModel.session)
        }
    }
    
    @IBAction func FilterButtonClicked(_ sender: UIButton) {
        self.logTableViewModel.setUpdatedMode(updateMode: .filterMode)
        guard self.logTableViewModel.status == .not_updating else {
            return
        }
        guard let dropdownListViewController = self.dropdownListViewController else {
            return
        }
        dropdownListViewController.modalPresentationStyle = .popover
        dropdownListViewController.preferredContentSize = CGSize(width: 150, height: 280)
        let popoverWriteValueCharacteristic = dropdownListViewController.popoverPresentationController
        popoverWriteValueCharacteristic?.permittedArrowDirections = .any
        popoverWriteValueCharacteristic?.delegate = self
        popoverWriteValueCharacteristic?.sourceView = sender
        self.present(dropdownListViewController, animated: false, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //MARK  Call Back handles
    @objc func invalidateLog() {
    
    }
    
    // Change this method to visible view cell
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.logTableViewModel.chosenUpdateMode != .filterMode else {
            hideMessageBar()
            return
        }
        guard let cellIndex = logTableView.visibleCells.last?.tag else {
            return
        }
        if cellIndex < logTableViewModel.viewRecords.count - 1 {
            self.logTableViewModel.setUpdatedMode(updateMode: LogTableViewModel.updateMode.manually)
        } else {
            self.logTableViewModel.setUpdatedMode(updateMode: LogTableViewModel.updateMode.automaticly)
            hideMessageBar()
        }
    }
    
    fileprivate func scrollToLatest() {
        guard self.logTableViewModel.chosenUpdateMode != .filterMode else {
            return
        }
        self.logTableView.scrollToRow(at: self.getIndexPath(self.logTableViewModel.viewRecords.count-1), at: .bottom, animated: true)
        self.logTableViewModel.setUpdatedMode(updateMode: LogTableViewModel.updateMode.automaticly)
    }
    
    //MARK: -Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.logTableViewModel.chosenUpdateMode == .filterMode {
            return logTableViewModel.filterRecords.count
        } else {
            return logTableViewModel.viewRecords.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: LogTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LogTableViewCell", for: indexPath) as! LogTableViewCell
        var cellVM: Log!
        if self.logTableViewModel.chosenUpdateMode == .filterMode {
            cellVM = logTableViewModel.filterRecords[indexPath.row]
        } else {
            cellVM = self.logTableViewModel.viewRecords[indexPath.row]
        }
        guard cellVM != nil else {
            return cell
        }
        cell.timeSlot.text = cellVM.timeStamp.logViewFormat
        cell.record.text = cellVM.activity
        cell.tag = indexPath.row
        setRecordColor(&cell, cellVM: cellVM)
        return cell
    }
    
    func setRecordColor(_ cell: inout LogTableViewCell, cellVM: Log)
    {
        switch cellVM.logType {
        case .application:
            cell.record.textColor = UIColor.green
        case .debug:
            cell.record.textColor = UIColor.blue
        case .info:
            cell.record.textColor = UIColor.black
        case .verbose:
            cell.record.textColor = UIColor.nordicYellow()
        case .warning:
            cell.record.textColor = UIColor.orange
        case .error:
            cell.record.textColor = UIColor.red
        }
    }
}
