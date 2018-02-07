//
//  DatFileSelectionViewController.swift
//  nRFConnect
//
//  Created by Jiajun Qiu on 15/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

class DatFileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var datFilesViewModel: DatFileViewModel = DatFileViewModel()
    @IBOutlet weak var datFilesTableView: UITableView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func viewDidLoad() {
        datFilesTableView.delegate = self
        datFilesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationButtonStatus()
        if self.datFilesViewModel.isDatFileFound {
            self.messageLabel.isHidden = true
        } else {
            self.messageLabel.isHidden = false
        }
    }
    
    private func setNavigationButtonStatus() {
        if self.datFilesViewModel.selectedRow == nil {
            self.datFilesViewModel.navigationButtonStatus = .skip
        } else {
            self.datFilesViewModel.navigationButtonStatus = .next
        }
        self.nextButton.title = self.datFilesViewModel.navigationButtonStatus.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datFilesViewModel.cellViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DatFilesCellViewController = self.datFilesTableView.dequeueReusableCell(withIdentifier: "DatFilesCell", for: indexPath) as! DatFilesCellViewController
        let row = indexPath.row
        let cellVM = datFilesViewModel.cellViewModel[row]
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
        self.datFilesViewModel.setSelectRow(atRow: indexPath.row)
        _ = self.datFilesViewModel.modifyFirmware()
        setNavigationButtonStatus()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cellView = getCellView(indexPath)
        cellView.accessoryType = .none
        self.datFilesViewModel.unsetSelectRow()
    }
    
    fileprivate func getCellView(_ indexPath: IndexPath) -> DatFilesCellViewController
    {
        let cellView = self.datFilesTableView.cellForRow(at: indexPath) as! DatFilesCellViewController
        return cellView
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete
//        {
//            self.datFilesViewModel.removeCell(atRow: indexPath.row)
//            _ = self.datFilesViewModel.modifyFirmware()
//            self.datFilesTableView.deleteRows(at: [indexPath], with: .fade)
//        }
//        setNavigationButtonStatus()
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! FileTypeViewController
        destination.fileTypeViewModel.firmware = self.datFilesViewModel.firmware
    }
}
