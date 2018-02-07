//
//  AdvertiserViewController.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 18/05/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

extension AdvertiserViewController {
    @objc func editButtonPressed() {
        DispatchQueue.main.async {
                guard self.advertiserViewModel.advTableStatus == .viewing else { self.popAlert(); return }
                self.navigationItem.rightBarButtonItem = nil
                self.advertiserTableView.isEditing = true
                self.advertiserViewModel.setTableStatus(status: .editing)
                self.navigationItem.leftBarButtonItem = self.doneButton
            }
    }
    
    func popAlert(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Edit failed", message: "This list can not be edited when one or more advertiser are switched on.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            })
            self.present(alert, animated: true)
        }
    }
    
    @objc func doneButtonPressed() {
        DispatchQueue.main.async {
                self.advertiserTableView.isEditing = false
                self.advertiserViewModel.setTableStatus(status: .viewing)
                if self.advertiserViewModel.advertiserCells.count > 0 {
                    self.navigationItem.leftBarButtonItem = self.editButton
                } else {
                    self.navigationItem.leftBarButtonItem = nil
                }
                self.navigationItem.rightBarButtonItem = self.addButton
                self.advertiserViewModel.saveAdvertisers()
                self.advertiserTableView.reloadData()
            }
        }
}

extension AdvertiserViewController: AdvertiseConfigurationDelegate {
    
    func didFinishConfiguration(updatedAdvertiser: AdvertiserBaseViewModel) {
        let index = self.advertiserViewModel.updateAdvertiser(advertiser: updatedAdvertiser)
        let indexPath = self.advertiserTableView.getIndexPath(index)
        self.advertiserTableView.beginUpdates()
        self.advertiserTableView.reloadRows(at: [indexPath], with: .automatic)
        self.advertiserTableView.endUpdates()
        self.advertiserTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

extension AdvertiserViewController: AdvertiserCellViewModelDelegate {
    func didStartAdvertising(createdAt: String) {
        
    }
    
    func didSucessStartAdvertising(hasSucceed: Bool, createdAt: String) {
        guard let index = self.advertiserViewModel.findAdvertiser(createdAt: createdAt) else {
            return
        }
        self.advertiserTableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
    }
    
    func didUpdateState(state: CBManagerStatus) {
        
    }
}

extension AdvertiserViewController: AppStatusTransitionDelegate {
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        self.advertiserTableView.reloadData()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.advertiserViewModel.saveAdvertisers()
    }
}

class AdvertiserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var advertiserTableView: UITableView!
    @IBOutlet weak var placeHolderView: UIView!
    
    let configurationSegue = "advertiserConfiguration"
    
    var advertiserViewModel: AdvertiserViewModel!
    var doneButton: UIBarButtonItem!
    var editButton: UIBarButtonItem!
    var addButton: UIBarButtonItem!

    override func viewDidLoad() {
        advertiserViewModel = AdvertiserViewModel()
        self.advertiserTableView.delegate = self
        self.advertiserTableView.dataSource = self
        self.advertiserTableView.rowHeight = UITableViewAutomaticDimension
        advertiserTableView.estimatedRowHeight = 140
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.registerViewController(vc: self)
        advertiserViewModel.tryReadAdvertiser()
    }
    
    override func viewWillLayoutSubviews() {
        self.doneButton = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonPressed))
        self.editButton = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(self.editButtonPressed))
        self.addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonTapped))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard advertiserViewModel.advertiserCells.count > 0 else {
            return 0
        }
        self.placeHolderView.isHidden = true
        if self.advertiserViewModel.advTableStatus == .editing {
            self.navigationItem.leftBarButtonItem = self.doneButton
        } else if self.advertiserViewModel.advTableStatus == .viewing {
            self.navigationItem.leftBarButtonItem = self.editButton
        }
        return advertiserViewModel.advertiserCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdvertiserViewCell") as! AdvertiserViewCell
        let cellVM = self.advertiserViewModel.advertiserCells[indexPath.row]
        cell.deviceName.text = cellVM.deviceName
        cell.localName.text = cellVM.localName
        cell.serviceUUID.text = cellVM.uuidString()
        cell.advertiserSwitchButton.isOn = cellVM.isOnAdvertising
        if cellVM.isOnAdvertising {
            changeCellColor(color: UIColor.groupTableViewBackground, atRow: cell)
        } else {
            changeCellColor(color: UIColor.white, atRow: cell)
        }
        cell.advertiserSwitchButton.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        let cellVM = self.advertiserViewModel.advertiserCells[indexPath.row]
        guard !self.advertiserViewModel.anyAdvertiserOn() else {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        guard !self.advertiserTableView.isEditing else {
            return .delete
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let cellVM = self.advertiserViewModel.advertiserCells[indexPath.row]
        guard !cellVM.hasBeenSwitchedOn else { return }
        let count = self.advertiserViewModel.removeAdvertiser(atRow: indexPath.row)
        self.advertiserTableView.deleteRows(at: [self.advertiserTableView.getIndexPath(indexPath.row)], with: .automatic)
        guard count != 0 else {
            self.placeHolderView.isHidden = false
//            self.navigationItem.leftBarButtonItem = nil
//            self.navigationItem.rightBarButtonItem = self.addButton
//            self.advertiserTableView.isEditing = false
            self.doneButtonPressed()
            return
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.advertiserViewModel.changeAdvertiserPriority(oldPosition: sourceIndexPath.row, newPosition: destinationIndexPath.row)
    }
    
    @objc func addButtonTapped(_ sender: UIBarButtonItem) {
        guard self.advertiserViewModel.advTableStatus != .editing else { return }
        let index = self.advertiserViewModel.addDefaultAdvertiser()-1
        let indexPath = self.advertiserTableView.getIndexPath(index)
        self.advertiserTableView.beginUpdates()
        self.advertiserTableView.insertRows(at: [indexPath], with: .automatic)
        self.advertiserTableView.endUpdates()
        self.advertiserTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        self.advertiserTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        self.performSegue(withIdentifier: configurationSegue, sender: sender)
        guard self.navigationItem.leftBarButtonItem == nil else { return }
        self.navigationItem.leftBarButtonItem = editButton
    }
    
    @IBAction func advertiserSwitchTapped(_ sender: UISwitch) {
        guard self.advertiserViewModel.advTableStatus != .editing else {
            return
        }
        let cellVM = self.advertiserViewModel.advertiserCells[sender.tag]
        let cell = self.advertiserTableView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! AdvertiserViewCell
        if cellVM.hasBeenSwitchedOn {
            advertiserViewModel.turnOffAdvertiser(index: sender.tag).advertiserCellDelegate = nil
            changeCellColor(color: UIColor.white, atRow: cell)
            if !self.advertiserViewModel.anyAdvertiserOn() {
                self.advertiserViewModel.setTableStatus(status: .viewing)
            }
        } else {
            advertiserViewModel.turnOnAdvertiser(index: sender.tag).advertiserCellDelegate = self
            changeCellColor(color: UIColor.groupTableViewBackground, atRow: cell)
            self.advertiserViewModel.setTableStatus(status: .busying)
        }
    }
    
    
    private func changeCellColor(color: UIColor, atRow: AdvertiserViewCell) {
        atRow.contentView.backgroundColor = color
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == configurationSegue else { return }
        let vc = segue.destination as! AdvertiseConfigurationViewController
        let index = self.advertiserTableView.indexPathForSelectedRow?.row
        let cellVM = self.advertiserViewModel.advertiserCells[index!]
        vc.configurationViewModel = AdvertiseConfigurationViewModel(advtiserID: cellVM.advertiserID, localName: cellVM.localName, serviceUUID: cellVM.serviceUUID)
        vc.configurationViewModel.configurationStatusDelegate = self
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == configurationSegue {
            guard let row = self.advertiserTableView.indexPathForSelectedRow?.row else { return false }
            let cellVM = self.advertiserViewModel.advertiserCells[row]
            if cellVM.hasBeenSwitchedOn { return false }
            else { return true }
        } else { return false }
    }
}
