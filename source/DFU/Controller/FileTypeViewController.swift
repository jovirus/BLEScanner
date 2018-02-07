//
//  FileTypeViewController.swift
//  nRFConnect
//
//  Created by Jiajun Qiu on 20/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

class FileTypeViewController: AlertViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var fileTypesTableView: UITableView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var fileTypeViewModel = FileTypeViewModel()
    
    override func viewDidLoad() {
        fileTypesTableView.delegate = self
        fileTypesTableView.dataSource = self
        self.alertViewControllerProtocol = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationButtonStatus()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        let parentVC = self.navigationController?.presentingViewController as! DFUMainNavigationController
        //UserfirmwareList is the only page at this momemt
        let userFirmwareListVC = parentVC.viewControllers.first as! UserFirmwareListViewController
        if self.fileTypeViewModel.isFirmwareReady() {
            if userFirmwareListVC.userFirmwareListViewModel.isFileExisted(file: self.fileTypeViewModel.firmware) {
                //Alert controller pop up
                self.showAlert()
            } else {
                userFirmwareListVC.userFirmwareListViewModel.addUserFirmware(file: self.fileTypeViewModel.firmware)
                self.dismiss(animated: true)
            }
        }
    }
    
    private func setNavigationButtonStatus () {
        if !self.fileTypeViewModel.isFirmwareReady() {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fileTypeViewModel.cellViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FileTypesTableCellViewController = self.fileTypesTableView.dequeueReusableCell(withIdentifier: "FileTypeCell", for: indexPath) as! FileTypesTableCellViewController
        let row = indexPath.row
        let cellVM = fileTypeViewModel.cellViewModel[row]
        cell.firmwareType.text = cellVM.firmwareType
        cell.accessoryType = .none
        cell.selectionStyle = .none
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellView = getCellView(indexPath)
        cellView.accessoryType = .checkmark
        self.fileTypeViewModel.setSelectRow(atRow: indexPath.row)
        _ = self.fileTypeViewModel.modifyFirmware()
        setNavigationButtonStatus()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cellView = getCellView(indexPath)
        cellView.accessoryType = .none
        self.fileTypeViewModel.unsetSelectRow()
    }
    
    fileprivate func getCellView(_ indexPath: IndexPath) -> FileTypesTableCellViewController
    {
        let cellView = self.fileTypesTableView.cellForRow(at: indexPath) as! FileTypesTableCellViewController
        return cellView
    }
}
