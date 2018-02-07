//
//  GenericAttributeProfilesViewController.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 14/08/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

extension GenericAttributeProfilesViewController: GenericAttributeProfilesProtocol {
    func didFindGattUUID(hasFound: Bool) {
        DispatchQueue.main.async {
            self.searchBar.showsCancelButton = true
            self.profilesTableView.beginUpdates()
            self.profilesTableView.reloadData()
            self.profilesTableView.endUpdates()
        }
    }
}

class GenericAttributeProfilesViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var profilesTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private var defaultRowHeight = CGFloat(44)
    
    var gapViewModel = GenericAttributeProfilesViewModel()
    override func viewDidLoad() {
        self.profilesTableView.delegate = self
        self.profilesTableView.dataSource = self
        self.searchBar.delegate = self
        self.searchBar.returnKeyType = .done
        self.gapViewModel.gapsProtocol = self
        self.searchBar.showsCancelButton = false
        self.profilesTableView.keyboardDismissMode = .onDrag
        self.profilesTableView.rowHeight = UITableViewAutomaticDimension
        self.profilesTableView.estimatedRowHeight = defaultRowHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gapViewModel.profilesCells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if gapViewModel.isSearching {
            let height = self.gapViewModel.profilesCells[indexPath.row].isSearchResult ? UITableViewAutomaticDimension : CGFloat(0)
            return height
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenericAttributeProfilesCell", for: indexPath) as! GenericAttributeProfilesCell
        let cellVM: GenericAttributeProfilesViewCell!
        cellVM = gapViewModel.profilesCells[indexPath.row]
        if let selectedUUID = self.gapViewModel.selectedGattUUID, cellVM.index == selectedUUID.index {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        } else {
            cell.accessoryType = .none
        }
        cell.serviceName.text = cellVM.serviceName
        cell.uuid.text = cellVM.uuid
        cell.tag = cellVM.index
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // This section only works when the table view remain the same, otherwise it will be refreshed, but those chosen one still will be cached. ref to cellForRowAt method
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        self.gapViewModel.selectRow(index: indexPath)
        cell.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        self.gapViewModel.selectRow(index: nil)
        cell.accessoryType = .none
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        gapViewModel.clearSearchMark()
        gapViewModel.searchingModeSwitch(isOn: false)
        self.searchBar.endEditing(true)
        self.searchBar.showsCancelButton = false
        profilesTableView.beginUpdates()
        profilesTableView.reloadData()
        profilesTableView.endUpdates()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        gapViewModel.findRelativeGattService(input: searchText)
    }
    
    private func dissmissKeyboard() {
        self.searchBar.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.gapViewModel.selectRow(index: self.profilesTableView.indexPathForSelectedRow)
        self.gapViewModel.doneSelection()
    }
    
}
