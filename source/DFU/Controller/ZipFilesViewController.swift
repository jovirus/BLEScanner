//
//  UserFilesViewController.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 29/11/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit
class ZipFilesViewController: AlertViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var zipFilesTableView: UITableView!
    @IBOutlet weak var DoneButton: UIBarButtonItem!
    @IBOutlet weak var CancelButton: UIBarButtonItem!
    
    fileprivate var zipFilesViewModel: ZipFilesViewModel!
    
    override func viewDidLoad() {
        self.zipFilesViewModel = ZipFilesViewModel()
        self.zipFilesTableView.delegate = self
        self.zipFilesTableView.dataSource = self
        self.alertViewControllerProtocol = self
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavigationButtonStatus()
    }

    
    fileprivate func setNavigationButtonStatus() {
        if self.zipFilesViewModel.isFirmwareReady() {
            self.DoneButton.isEnabled = true
        } else {
            self.DoneButton.isEnabled = false
        }
    }
    
    @IBAction func DoneButtonPressed(_ sender: UIBarButtonItem) {
        let parentVC = self.navigationController?.presentingViewController as! DFUMainNavigationController
        //UserfirmwareList is the only page at this momemt
        let userFirmwareListVC = parentVC.viewControllers.first as! UserFirmwareListViewController
        _ = self.zipFilesViewModel.creatFirmware()
        if self.zipFilesViewModel.isFirmwareReady() {
            if let result = self.zipFilesViewModel.creatFirmware() {
                if userFirmwareListVC.userFirmwareListViewModel.isFileExisted(file: result) {
                    //Alert controller pop up
                    self.showAlert()
                } else {
                    userFirmwareListVC.userFirmwareListViewModel.addUserFirmware(file: result)
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    @IBAction func CancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == ZipFilesViewModel.ZipFilesSection {
            var cell: ZipFilesCellViewController!
            cell = self.zipFilesTableView.dequeueReusableCell(withIdentifier: "ZipFilesSection") as! ZipFilesCellViewController
            let cellVM = self.zipFilesViewModel.cellViewModel[indexPath.row]
            cell.fileName.text = cellVM.fileName
            cell.accessoryType = .none
            cell.selectionStyle = .none
            return cell
        } else {
            var cell: HelpSectionViewController!
            cell = self.zipFilesTableView.dequeueReusableCell(withIdentifier: "HelpSection") as! HelpSectionViewController
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == ZipFilesViewModel.ZipFilesSection {
            let cellView = getCellView(indexPath)
            self.zipFilesViewModel.setSelectRow(atRow: indexPath.row)
            cellView.accessoryType = .checkmark
            self.zipFilesViewModel.setSelectRow(atRow: indexPath.row)
            self.DoneButton.isEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == ZipFilesViewModel.ZipFilesSection {
            self.zipFilesViewModel.unsetSelectRow()
            let cellView = getCellView(indexPath)
            cellView.accessoryType = .none
        }
    }

    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete
//        {
//            self.zipFilesViewModel.removeCell(atRow: indexPath.row)
//            self.zipFilesTableView.deleteRows(at: [indexPath], with: .fade)
//        }
//        setNavigationButtonStatus()
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 0
        if section == ZipFilesViewModel.HelperSection {
            numberOfRow = 1
        } else if section == ZipFilesViewModel.ZipFilesSection {
            numberOfRow = self.zipFilesViewModel.cellViewModel.count
        }
        return numberOfRow
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat(0)
        if indexPath.section == ZipFilesViewModel.HelperSection {
            height = 80
        } else if indexPath.section == ZipFilesViewModel.ZipFilesSection {
            height = 44
        }
        return height
    }
    
    fileprivate func getCellView(_ indexPath: IndexPath) -> ZipFilesCellViewController
    {
        let cellView = self.zipFilesTableView.cellForRow(at: indexPath) as! ZipFilesCellViewController
        return cellView
    }
}
