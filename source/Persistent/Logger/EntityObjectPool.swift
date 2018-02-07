//
//  nRFPersistent.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 15/04/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
/**
 This class is design to store objects that are needed to be persistent. Those values are stored temporary in memory. 
 They can be easy accessed in application layer and logic layer.
 */
internal class EntityObjectPool: Pool {
    //MARK: - Object. log objects, access method are provided only for interal access.
    var records = SynchronizedArray<Log>(debug: "Log")

    //MARK: - Object. A connected device via ble is called nRF Device, could be Gatt service or client
    var nrfDevice: [nRFDevice] = []

    //MARK: - Object. BLE Session is used to resigster any connect based on bluetooth ATT protocol
    var bleSession: [BLESession] = []
    
    //MARK: - Object. iPhone/iPad act as advertiser.
    var peripheral = AdvertiserList()

    //MARK: - Relation. logs can only be created under a session.
    var log_BLESession: [Log_BLESession] = []
}
