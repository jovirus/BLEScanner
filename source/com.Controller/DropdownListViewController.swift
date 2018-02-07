//
//  DropdownListViewController.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 10/05/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import UIKit

protocol DropdownListViewControllerDelegate {
    func userChosenLogLevel(_ logLevel: LogType!)
}

class DropdownListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var contentTableView: UITableView!
    var dropdownlistViewModel = DropdownlistViewModel()
    var dropdownListViewControllerDelegate: DropdownListViewControllerDelegate!
    
    var userChosenLogLevel: UserChoseLogLevelFilter!
    
    override func viewDidLoad() {
        contentTableView.dataSource = self
        contentTableView.delegate = self
        contentTableView.rowHeight = UITableViewAutomaticDimension
        contentTableView.alwaysBounceVertical = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dropdownlistViewModel.listOfContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DropdownListViewCell = tableView.dequeueReusableCell(withIdentifier: "DropdownListContentCell", for: indexPath) as! DropdownListViewCell
        let row = (indexPath as NSIndexPath).row
        let cellVM = self.dropdownlistViewModel.listOfContents[row]
        cell.accessoryType = .none
        cell.selectionStyle = .none;
        cell.NameLabel.text = String(cellVM.nameID)
        cell.NameLabel.textColor = UIColor.nordicBlue()
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellView = getCellView(indexPath)
        if cellView.accessoryType == .checkmark
        {
            cellView.accessoryType = .none
            contentTableView.deselectRow(at: indexPath, animated: false)
        } else
        {
            cellView.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cellView = getCellView(indexPath)
        cellView.accessoryType = .none
    }

    func getCellView(_ indexPath: IndexPath) -> DropdownListViewCell
    {
        let cellView = contentTableView.cellForRow(at: indexPath) as! DropdownListViewCell
        return cellView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let selectedRow = self.contentTableView.indexPathForSelectedRow
        self.dropdownListViewControllerDelegate.userChosenLogLevel(selectedRow != nil ? self.dropdownlistViewModel.listOfContents[(selectedRow! as NSIndexPath).row].logLevel : nil)
    }
    
    func getIndexPath(_ cellIndex: Int) ->IndexPath
    {
        let indexPath = IndexPath(row: cellIndex, section: 0)
        return indexPath
    }
}
