//
//  AdvertiserModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 24/07/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

class AdvertiserModel {
    var id: String!
    var deviceName: String!
    var advertisement: AdvertisementPackageWrapper!
    var peer : CBPeripheralManager!

    init(localName: String, advertisement: AdvertisementPackageWrapper) {
        self.deviceName = localName
        self.advertisement = advertisement
    }
}

//extension AdvertiserModel: BLEPeerManagerDelegate {
//    func addService(service: [GattServerService]) {
//        print("add service method called")
//        var services = [CBMutableService]()
//        for item in service {
//            let mService = CBMutableService(type: item.AssignedNumber, primary: item.isPrimary)
//            services.append(mService)
//        }
//        //BLEPeerManager.instance.addService(services: services)
//    }
//    
//    func addCharacteristics(charact: [GattServerCharacteristic], service: CBMutableService) {
//        for item in charact {
//            let mCharact = CBMutableCharacteristic(type: item.AssignedNumber, properties: item.properties, value: item.value, permissions: item.permissions)
//            service.characteristics?.append(mCharact)
//        }
//    }
//    
//    //localName: String, serviceUUID: CBUUID
//    func startAdvertise(advModel: AdvertiserModel) {
//        print("start advertise method called")
//        let advPacket: [String: Any] = [CBAdvertisementDataLocalNameKey: advModel.advertisement.cBAdvertisementDataLocalName, CBAdvertisementDataServiceUUIDsKey
//            : [advModel.advertisement.cBAdvertisementDataServiceUUIDs]]
//        advManager.startAdvertising(advertisementData: advPacket, peerManager: self.peer)
//    }
//    
//    func stopAdvertise() {
//        print("stop advertise method called in adv model")
//        advManager.stopAdvertising(peerManager: self.peer)
//    }
//    
//    func didUpdateState(state: CBManagerStatus) {
//
//        switch state {
//            case .poweredOn:
//                print("is ready for advtising")
//                break
//            case .unsupported:
//                //warn user ios version is too low
//                break
//            default:
//                return
//        }
//    }
//    
//    func didStartAdvertising() {
//        print("started adverte callback")
//    }
//}
