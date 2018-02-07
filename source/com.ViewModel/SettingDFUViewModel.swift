//
//  SettingDFUViewModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 28/11/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation

class SettingDFUViewModel {
    fileprivate(set) var enableAlternativeName: Bool = true
    
    init() {
        self.enableAlternativeName = UserPreference.instance.enableAlternativeName
    }
    
    func shouldUseAlternativeName(_ useAlternativeName: Bool) {
        self.enableAlternativeName = useAlternativeName
    }
    
    func saveSettings() {
        UserPreference.instance.enableAlternativeName = self.enableAlternativeName
    }
}
