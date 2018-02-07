//
//  SettingScannerTimeOutPickerView.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 12/09/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

extension SettingScannerTimeOutPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.settingScannerPickerViewModel.timeoutOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.settingScannerPickerViewModel.timeoutOptions[row].description()
    }
}

class SettingScannerTimeOutPickerView: UIViewController {
    
    @IBOutlet weak var timeoutPicker: UIPickerView!
    var settingScannerPickerViewModel = SettingScannerTimeOutPickerViewModel()
    
    override func viewDidLoad() {
        self.timeoutPicker.delegate = self
        self.timeoutPicker.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let index = self.settingScannerPickerViewModel.timeoutOptions.index(of: self.settingScannerPickerViewModel.pickedTimeOut)
        self.timeoutPicker.selectRow(index!, inComponent: 0, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let timeOut = self.settingScannerPickerViewModel.timeoutOptions[self.timeoutPicker.selectedRow(inComponent: 0)]
        self.settingScannerPickerViewModel.setTimeOut(value: timeOut)
        self.settingScannerPickerViewModel.notifyChange()
    }
}
