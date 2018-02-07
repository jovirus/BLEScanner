//
//  AdvertiseConfigurationViewController.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 15/06/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

extension AdvertiseConfigurationViewController: GenericAttributeProfilesDelegate {
    
    func doneSelection(chosenService: GattUUID?) {
        guard let newService = chosenService else {
            return
        }
        self.configurationViewModel.serviceUUID.append(newService)
        serviceUUIDTableView.beginUpdates()
        serviceUUIDTableView.insertRows(at: [IndexPath.init(row: self.configurationViewModel.serviceUUID.count-1, section: 0)], with: .automatic)
        serviceUUIDTableView.endUpdates()
    }
}

class AdvertiseConfigurationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NameConfigurationDelegate {
    
    @IBOutlet weak var localNameValue: UILabel!
    @IBOutlet weak var serviceUUIDTableView: UITableView!
    
    var configurationViewModel: AdvertiseConfigurationViewModel!
    var defaultRowHeight = CGFloat(49)
    
    override func viewDidLoad() {
        self.serviceUUIDTableView.delegate = self
        self.serviceUUIDTableView.dataSource = self
        self.serviceUUIDTableView.estimatedRowHeight = defaultRowHeight
        self.serviceUUIDTableView.autoresizingMask = .flexibleHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && configurationViewModel.serviceUUID.count > 0 {
            return configurationViewModel.serviceUUID.count
        } else if section == 0 && configurationViewModel.serviceUUID.count == 0 {
            return 0
        } else if section == 1 {
            return 1
        } else { return 0 }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.serviceUUIDTableView.dequeueReusableCell(withIdentifier: "ChosenServiceSection", for: indexPath) as! ConfigurationServiceUUIDCell
            let cellVM = configurationViewModel.serviceUUID[indexPath.row]
            cell.serviceName.text = cellVM.GattName
            cell.uuid.text = cellVM.AssignedNumber.uuidString
            return cell
        } else {
            let cell = self.serviceUUIDTableView.dequeueReusableCell(withIdentifier: "AddButtonSection", for: indexPath) as! ConfigurationAddServiceCell
            cell.addButton.contentHorizontalAlignment = .center
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 0 {
            return .delete
        } else {
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.configurationViewModel.serviceUUID.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.localNameValue.text = configurationViewModel.localName
        self.serviceUUIDTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ServicesConfiguration" {
            let vc = segue.destination as! GenericAttributeProfilesViewController
            vc.gapViewModel.gapsDelegate = self
        } else if segue.identifier == "NameConfiguration" {
            let vc = segue.destination as! NameConfigurationViewController
            vc.nameConfigurationVM.nameConfigurationDelegate = self
            vc.nameConfigurationVM.setName(name: self.configurationViewModel.localName)
        }
    }
    
    func didNameEdited(name: String) {
        self.configurationViewModel.localName = name
        self.localNameValue.text = self.configurationViewModel.localName
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard self.isMovingFromParentViewController else {
            return
        }
        self.configurationViewModel.editingDone()
    }
}
