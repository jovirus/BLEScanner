//
//  AdvertiserCellViewModelDelegate.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 17/08/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation

protocol AdvertiserCellViewModelDelegate {
    func didUpdateState(state: CBManagerStatus)
    func didSucessStartAdvertising(hasSucceed: Bool, createdAt: String)
}
