//
//  AdvertiseConfigurationViewModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 16/06/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation

protocol AdvertiseConfigurationViewModelDelegate {
    func didFindGattUUID(isReady: Bool)
    func hasSuccessSetUUID(didAccept: Bool)
}

protocol AdvertiseConfigurationDelegate {
    func didFinishConfiguration(updatedAdvertiser: AdvertiserBaseViewModel)
}

class AdvertiseConfigurationViewModel: AdvertiserBaseViewModel {
    
    var advertiseConfigurationViewModelDelegate: AdvertiseConfigurationViewModelDelegate?
    var configurationStatusDelegate: AdvertiseConfigurationDelegate?
    
    func editingDone() {
        configurationStatusDelegate?.didFinishConfiguration(updatedAdvertiser: self)
    }
}
