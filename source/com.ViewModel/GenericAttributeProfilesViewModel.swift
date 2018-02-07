//
//  GenericAttributeProfilesViewModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 14/08/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
protocol GenericAttributeProfilesProtocol {
    func didFindGattUUID(hasFound: Bool)
}

protocol GenericAttributeProfilesDelegate {
    func doneSelection(chosenService: GattUUID?)
}

class GenericAttributeProfilesViewModel {
    var profilesCells: [GenericAttributeProfilesViewCell] = []
    var gapsProtocol: GenericAttributeProfilesProtocol?
    var gapsDelegate: GenericAttributeProfilesDelegate?
    
    private(set) var isSearching = false
    private(set) var selectedGattUUID: GenericAttributeProfilesViewCell?

    init() {
        initialiseProfiles()
    }
    
    func initialiseProfiles() {
        var id = 0
        for item in GattServiceUUID.gattServiceUuids.values {
            profilesCells.append(GenericAttributeProfilesViewCell(index: id, gatt: item))
            id += 1
        }
    }
    
    func selectRow(index: IndexPath?) {
        guard let indexPath = index else {
            selectedGattUUID = nil
            return
        }
        self.profilesCells[indexPath.row].selected = true
        selectedGattUUID = self.profilesCells[indexPath.row]
    }
    
    func doneSelection() {
        guard let chosen = selectedGattUUID else {
            gapsDelegate?.doneSelection(chosenService: nil)
            return
        }
        gapsDelegate?.doneSelection(chosenService: chosen.gattUUID)
    }
    
    func findRelativeGattService(input: String) {
        searchingModeSwitch(isOn: true)
        clearSearchMark()
        guard input != "" else {
            searchingModeSwitch(isOn: false)
            self.gapsProtocol?.didFindGattUUID(hasFound: false)
            return
        }
        let searchText = input.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard searchText != "" else {
            searchingModeSwitch(isOn: false)
            self.gapsProtocol?.didFindGattUUID(hasFound: false)
            return
        }
        let result = filterCells(keyWords: searchText)
        if result.count > 0 {
            for item in result {
                guard let index = profilesCells.index(where: { $0.gattUUID.AssignedNumber == item.gattUUID.AssignedNumber }) else {
                    continue
                }
                profilesCells[index].isSearchResult = true
            }
            gapsProtocol?.didFindGattUUID(hasFound: true)
        } else {
            gapsProtocol?.didFindGattUUID(hasFound: false)
        }
    }
    
    private func filterCells(keyWords: String) -> [GenericAttributeProfilesViewCell] {
        var result: [GenericAttributeProfilesViewCell] = []
        let input = keyWords.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard input != "" else { return result }
        let potentialCells1 = self.profilesCells.filter { (x) -> Bool in
            x.uuid.containsIgnoringCase(input)
        }
        for item in potentialCells1 {
            result.append(item)
        }
        let potentialCells2 = self.profilesCells.filter { (x) -> Bool in
            x.gattUUID.GattName.containsIgnoringCase(input)
        }
        for item in potentialCells2 {
            result.append(item)
        }
        return result
    }
    
    func searchingModeSwitch(isOn: Bool) {
        self.isSearching = isOn
    }
    
    func clearSearchMark() {
        self.profilesCells.forEach({ $0.isSearchResult = false })
    }
}
