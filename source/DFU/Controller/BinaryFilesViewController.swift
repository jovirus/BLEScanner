//
//  AppFilesViewController.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 28/11/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit
class BinaryFilesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var binaryFilesTableView: UITableView!
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    fileprivate var binaryFilesViewModel = BinaryFilesViewModel()

    
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
//        let parentVC = self.navigationController?.presentingViewController as! DFUDashboardViewController
//        //parentVC.dfuDashboardViewModel.setFirmware(url: self.exampleFilesViewModel.selectedRow.fileURL)
//        self.dismiss(animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        binaryFilesTableView.delegate = self
        binaryFilesTableView.dataSource = self
        self.navigationItem.title = "Binary files"
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        let ua = self.binaryFilesViewModel.firmware
//    }
    
//    override func viewWillLayoutSubviews() {
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationButtonStatus()
    }
    
    private func setNavigationButtonStatus() {
        if !self.binaryFilesViewModel.isFirmwareReady() {
            self.nextButton.isEnabled = false
        } else {
            self.nextButton.isEnabled = true
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.binaryFilesViewModel.cellViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BinaryFilesCellViewController = self.binaryFilesTableView.dequeueReusableCell(withIdentifier: "BinaryFilesCell", for: indexPath) as! BinaryFilesCellViewController
        let row = indexPath.row
        let cellVM = binaryFilesViewModel.cellViewModel[row]
        cell.FileName.text = cellVM.fileName
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
        self.binaryFilesViewModel.setSelectRow(index: indexPath)
        self.nextButton.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.binaryFilesViewModel.unsetSelectRow()
        let cellView = getCellView(indexPath)
        cellView.accessoryType = .none
    }
    
    fileprivate func getCellView(_ indexPath: IndexPath) -> BinaryFilesCellViewController
    {
        let cellView = self.binaryFilesTableView.cellForRow(at: indexPath) as! BinaryFilesCellViewController
        return cellView
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete
//        {
//            self.binaryFilesViewModel.removeCell(atRow: indexPath.row)
//            _ = self.binaryFilesViewModel.modifyFirmware()
//            self.binaryFilesTableView.deleteRows(at: [indexPath], with: .fade)
//        }
//        setNavigationButtonStatus()
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DatFileViewController
        destination.datFilesViewModel.firmware = self.binaryFilesViewModel.firmware
        }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var shouldGoNext = false
        _ = self.binaryFilesViewModel.modifyFirmware()
        if self.binaryFilesViewModel.isFirmwareReady() {
            shouldGoNext = true
        }
        setNavigationButtonStatus()
        return shouldGoNext
    }
}
