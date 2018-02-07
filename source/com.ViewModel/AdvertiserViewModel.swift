//
//  AdvertiserViewModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 14/06/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import CoreBluetooth

class AdvertiserViewModel {
    //var advertiserViewModelDelegate: AdvertiserViewModelDelegate?
    private(set) var advertiserCells : [AdvertiserCellViewModel] = []
    //Default status is viewing
    private(set) var advTableStatus: TableViewStatus = .viewing
    fileprivate var currentIndexAdvertiser: Int

    init() {
       currentIndexAdvertiser = advertiserCells.count
    }
    
    func setTableStatus(status: TableViewStatus) {
        self.advTableStatus = status
    }
    
    func findAdvertiser(createdAt: String) -> Int? {
        let result = self.advertiserCells.index(where: { (x) -> Bool in
            if x.createdAt == createdAt {
                return true
            } else {
                return false
            }
        })
        return result
    }
    
    func anyAdvertiserOn() -> Bool {
        if self.advertiserCells.contains(where: {$0.hasBeenSwitchedOn == true }) {
            setTableStatus(status: .busying)
            return true
        } else {
            return false
        }
    }
    
    func addDefaultAdvertiser() -> Int {
        return addAdvertiser(localName: generateDeviceName(), serviceUUID: [getService()])
    }
    
    fileprivate func addAdvertiser(localName: String, serviceUUID: [GattUUID]!) -> Int {
        let cellVM = AdvertiserCellViewModel(localName: localName, serviceUUID: serviceUUID)
        advertiserCells.append(cellVM)
        return advertiserCells.count
    }
    
    func removeAdvertiser(atRow: Int) -> Int {
        self.advertiserCells.remove(at: atRow)
        return self.advertiserCells.count
    }
    
    func changeAdvertiserPriority(oldPosition: Int, newPosition: Int) {
        let replaceableObj = self.advertiserCells[oldPosition]
        self.advertiserCells.remove(at: oldPosition)
        self.advertiserCells.insert(replaceableObj, at: newPosition)
    }
    
    func turnOnAdvertiser(index: Int) -> AdvertiserCellViewModel {
        let cellVM = self.advertiserCells[index]
        cellVM.hasBeenSwitchedOn = true
        cellVM.initializePeripheralAndStartAdvertise()
        return cellVM
    }
    
    func turnOffAdvertiser(index: Int) -> AdvertiserCellViewModel {
        let cellVM = self.advertiserCells[index]
        cellVM.hasBeenSwitchedOn = false
        cellVM.stopAdvertising(peerManager: cellVM.peripheral)
        return cellVM
    }
    
    func updateAdvertiser(advertiser: AdvertiserBaseViewModel) -> Int {
        let index = self.advertiserCells.index(where: {$0.advertiserID == advertiser.advertiserID})!
        self.advertiserCells[index].localName = advertiser.localName
        self.advertiserCells[index].serviceUUID = advertiser.serviceUUID
        return index
    }
}

extension AdvertiserViewModel  {
    // save user defined advertiser when user terminate the app by app switcher
    internal func saveAdvertisers() {
        let advers = AdvertiserList()
        advers.advertiserList = [Advertiser]()
        for index in 0..<self.advertiserCells.count {
            let advertiser = Advertiser()
            advertiser.id = index
            advertiser.deviceName = AppInfo.mobileName
            advertiser.localName = self.advertiserCells[index].localName
            for uuid in self.advertiserCells[index].serviceUUID {
                advertiser.uuids.append(uuid.AssignedNumber.uuidString)
            }
            advers.advertiserList?.append(advertiser)
        }
        LocalAccessManager.instance.saveAdvertiserList(advertisers: advers)
    }
    
    internal func tryReadAdvertiser() {
        if let result = LocalAccessManager.instance.readAdvertiserList(completion: { (url, error) in
        }) {
            for item in result {
                var uuid = [GattUUID]()
                for uuidString in item.uuids {
                    uuid.append(GattServiceUUID.getFormat(CBUUID.init(string: uuidString)))
                }
                let _ = addAdvertiser(localName: item.localName!, serviceUUID: uuid)
            }
        }
    }
    
    internal func generateDeviceName() -> String {
        let nRF = "nRF5x"
        let currentIndex = self.advertiserCells.count
        var name = ""
        if currentIndex == 0 {
            name = nRF
        } else {
            name = nRF + "_" + String(currentIndex)
        }
        return findName(name: name, currentIndex: currentIndex)
    }
    
    private func findName(name: String, currentIndex: Int) -> String {
        let result = self.advertiserCells.filter { (cell) -> Bool in
            if cell.deviceName == name {
                return true
            }
            return false
        }
        if result.count == 0 {
            return name
        } else {
            let newIndex = currentIndex + 1
            return findName(name: "nRF5x" + "_" + String(newIndex), currentIndex: newIndex)
        }
    }
    
    internal func getService() -> GattUUID {
        let totalOfInstalledServices = GattServiceUUID.gattServiceUuids.count
        if self.currentIndexAdvertiser >= totalOfInstalledServices {
            self.currentIndexAdvertiser = 0
        }
        
        let sequenceNr = Int(self.currentIndexAdvertiser % totalOfInstalledServices)
        let key = Array(GattServiceUUID.gattServiceUuids.keys)[sequenceNr]
        let value = GattServiceUUID.gattServiceUuids[key]
        self.currentIndexAdvertiser += 1
        return value!
    }
}
