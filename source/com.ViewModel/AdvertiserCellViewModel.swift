//
//  AdvertiserCellViewModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 14/06/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

class AdvertiserCellViewModel: AdvertiserBaseViewModel {
    var createdAt: String
    var hasBeenSwitchedOn: Bool = false
    //This can be delayed
    var isOnAdvertising: Bool! {
        get {
            if peripheral != nil {
                return peripheral.isAdvertising
            } else {
                return false
            }
        }
    }
    fileprivate(set) var peripheral: CBPeripheralManager!
    fileprivate(set) var session: BLESession!
    var advertiserCellDelegate: AdvertiserCellViewModelDelegate?

    var deviceName: String {
        get {
            return self.localName
        }
    }
    
    override init(localName: String, serviceUUID: [GattUUID]) {
        createdAt = Date().logViewFormat
        super.init(localName: localName, serviceUUID: serviceUUID)
//        isOnAdvertising = false
    }
    
    func uuidString() -> String {
        guard self.serviceUUID.count > 0 else {
            return Symbols.NOT_AVAILABLE
        }

        var index = 0
        var uuidViewString = ""
        while index < serviceUUID.count {
            uuidViewString += self.serviceUUID[index].AssignedNumber.uuidString + ";"
            index += 1
        }
        return uuidViewString
    }
}

extension AdvertiserCellViewModel: CBPeripheralManagerDelegate {
    
    func initializePeripheralAndStartAdvertise() {
        self.peripheral = CBPeripheralManager.init(delegate: self, queue: nil, options: [CBPeripheralManagerOptionShowPowerAlertKey: true, CBPeripheralManagerOptionRestoreIdentifierKey: self.createdAt])
    }
    
    private func startAdvertising() {
        let advPacket: [String: Any] = [CBAdvertisementDataLocalNameKey: self.localName, CBAdvertisementDataServiceUUIDsKey
            : self.getUUIDS(), CBPeripheralManagerRestoredStateAdvertisementDataKey: "advData"]
        self.startAdvertising(advertisementData: advPacket, peerManager: peripheral)
    }
    
    private func startAdvertising(advertisementData: [String : Any], peerManager: CBPeripheralManager) {
        peerManager.startAdvertising(advertisementData)
    }
    
    open func stopAdvertising(peerManager: CBPeripheralManager) {
        peerManager.stopAdvertising()
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if #available(iOS 10.0, *) {
            let status = CBManagerStatus.getStatus(state: peripheral.state)
            switch status {
            case .poweredOn:
                startAdvertising()
            default:
                self.advertiserCellDelegate?.didUpdateState(state: status)
                self.advertiserCellDelegate?.didSucessStartAdvertising(hasSucceed: false, createdAt: self.createdAt)
            }
        } else {
            // Fallback on earlier versions
            // Not able to use the advertiser
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        self.advertiserCellDelegate?.didSucessStartAdvertising(hasSucceed: true, createdAt: self.createdAt)
    }
    
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {
        // For apps that opt in to the state preservation and restoration feature of Core Bluetooth, this is the first method invoked when your app is relaunched into the background to complete some Bluetooth-related task. Use this method to synchronize the state of your app with the state of the Bluetooth system.
        print("app restored................. \(dict)")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        
    }
}

extension AdvertiserCellViewModel: LogProtocol {
    
    func createSession() -> BLESession {
        //For efficiency, not all advertiser can be taken into account in one app, therefor iOS might squeeze in advpacket into one.
        self.session = AdvertiserSessionManager.createSession(forDevice: self.restoreIdentifierKey, deviceName: self.localName, peripheralConnectionStatus: .disconnected)
        return self.session
    }
}
