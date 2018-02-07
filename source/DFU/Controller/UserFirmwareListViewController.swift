//
//  UserDFListViewController.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 30/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit
class UserFirmwareListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UserFirmwareListViewModelDelegate {
    
    @IBOutlet weak var addFirmware: UIBarButtonItem!
    var closeButton: UIBarButtonItem!
    var saveButton: UIBarButtonItem!
    @IBOutlet weak var userFirmwareTable: UITableView!
    @IBOutlet weak var noFirmwareLabel: UILabel!
    
    var userFirmwareListViewModel: UserFirmwareListViewModel!
    
    override func viewDidLoad() {
        let parentVC = self.parent as! DFUMainNavigationController
        userFirmwareListViewModel = UserFirmwareListViewModel(centralMananger: parentVC.dfuMainViewModel.centralMananger, peripheral: parentVC.dfuMainViewModel.peripheral, device: parentVC.dfuMainViewModel.selectedDevice, session: parentVC.dfuMainViewModel.session)
        self.userFirmwareTable.delegate = self
        self.userFirmwareTable.dataSource = self
        _ = self.userFirmwareListViewModel.restoreUserFirmware()
        UITabBar.appearance().tintColor = UIColor.nordicGray()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.nordicGray()], for: .selected)
    }
    
    private func showNoFirmwareLabel() {
        self.noFirmwareLabel.isHidden = false
    }
    
    private func hideNoFirmwareLabel() {
        self.noFirmwareLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.userFirmwareListViewModel.userFirmwareListViewModelDelegate = self
        closeButtonStatusChange(hasModified: self.userFirmwareListViewModel.isFileListModified)
        if self.userFirmwareListViewModel.userFirmwareCellVMList.count == 0 {
            showNoFirmwareLabel()
        } else {
            hideNoFirmwareLabel()
        }
    }
    
    @objc func closeButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed(_ sender: UIBarButtonItem) {
        self.userFirmwareListViewModel.saveUserFirmware()
    }
    
    override func viewWillLayoutSubviews() {
        self.closeButton = UIBarButtonItem.init(title: UserFirmwareListViewModel.contentStatus.closeButton.rawValue, style: .plain, target: self, action: #selector(self.closeButtonPressed))
        self.saveButton = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(self.saveButtonPressed))
        self.navigationItem.leftBarButtonItem = self.closeButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userFirmwareListViewModel.userFirmwareCellVMList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.userFirmwareTable.dequeueReusableCell(withIdentifier: "UserFirmwareCell") as! UserFirmwareCellViewController
        let cellVM = self.userFirmwareListViewModel.userFirmwareCellVMList[indexPath.row]
        cell.firmwareName.text = cellVM.firmwareName
        cell.type.text = cellVM.firmwareKind?.rawValue
        cell.ceatedTime.text = cellVM.savedAt?.fileViewFormat
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            if self.userFirmwareListViewModel.removeCell(atRow: indexPath.row) {
                self.userFirmwareTable.deleteRows(at: [indexPath], with: .fade)
                if self.userFirmwareListViewModel.userFirmwareCellVMList.count == 0 {
                    showNoFirmwareLabel()
                } else {
                    hideNoFirmwareLabel()
                }
            } else {
                // data out of date
            }
        }
    }
    
    func hasFileListModified(hasModified: Bool) {
        closeButtonStatusChange(hasModified: hasModified)
    }
    
    private func closeButtonStatusChange(hasModified: Bool) {
        if hasModified {
            self.navigationItem.leftBarButtonItem = self.saveButton
        } else {
            self.navigationItem.leftBarButtonItem = self.closeButton
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func newFirmwareAdded(cell: UserFirmwareTableCellViewModel) {
        self.userFirmwareTable.beginUpdates()
        self.userFirmwareTable.insertRows(at: [IndexPath.init(row: userFirmwareListViewModel.userFirmwareCellVMList.count-1 , section: 0)], with: .automatic)
        self.userFirmwareTable.endUpdates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailFirmware" {
            let destination = segue.destination as! DFUDetailViewController
            let row = self.userFirmwareTable.indexPathForSelectedRow?.row
            self.userFirmwareListViewModel.setSelectedRow(row: row!)
            let dfuFile = self.userFirmwareListViewModel.selectRow?.dfuFile.isType()
            destination.dfuDetailViewModel = DFUDetailViewModel(centralMananger: self.userFirmwareListViewModel.centralMananger, peripheral: self.userFirmwareListViewModel.peripheral, device: userFirmwareListViewModel.selectedDevice, session: userFirmwareListViewModel.session)
            if dfuFile is LegacyDFUFile {
                destination.dfuDetailViewModel.setFirmware(file: dfuFile as! LegacyDFUFile)
            } else if dfuFile is SecurityDFUFile {
                destination.dfuDetailViewModel.setFirmware(file: dfuFile as! SecurityDFUFile)
            }
        } else if segue.identifier == "AddFirmware" {
        
        
        }
    }
}
