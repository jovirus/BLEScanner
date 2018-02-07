//
//  NameConfigurationViewController.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 16/08/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

class NameConfigurationViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var localNameTextField: UITextField!
    
    var nameConfigurationVM = NameConfigurationViewModel()
    override func viewDidLoad() {
        self.localNameTextField.text = nameConfigurationVM.name
        self.localNameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.localNameTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let value = self.localNameTextField.text {
            self.nameConfigurationVM.setName(name: value)
        } else {
            self.nameConfigurationVM.setName(name: "")
        }
        self.nameConfigurationVM.nameEditingDone()
    }
}
