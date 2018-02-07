//
//  NameConfigurationViewModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 16/08/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation

protocol NameConfigurationDelegate {
    func didNameEdited(name: String)
}

class NameConfigurationViewModel {
    var nameConfigurationDelegate: NameConfigurationDelegate?
    
    private(set) var name: String = ""
    
    func setName(name: String) {
        self.name = name
    }
    
    func nameEditingDone() {
        nameConfigurationDelegate?.didNameEdited(name: self.name)
    }
    
    
}
