//
//  WriteValuePopoverViewController.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 21/10/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
import QuartzCore

protocol WriteValuePopoverDelegate {
    func userInputReady(_ value: WrittenValueWrapper)
}

open class WriteValuePopoverViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var WriteType: UISegmentedControl!
    @IBOutlet weak var WriteTypeLabel: UILabel!
    @IBOutlet weak var SendButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var NewValueTextField: UITextField!
    var operationProperties = [String]()
    var isWrittingToDescriptor: Bool = false
    
    static let instance = WriteValuePopoverViewController()
    
    let WRITE_TYPE_COMMAND = 0
    let WRITE_TYPE_REQUEST = 1

    var writeValuePopoverDelegate: WriteValuePopoverDelegate?
    var popUpWrapper: WrittenValueWrapper = WrittenValueWrapper()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        NewValueTextField.delegate = self
        let withResponse = operationProperties.contains(DataConvertHelper.properties.Write)
        let withoutResponse = operationProperties.contains(DataConvertHelper.properties.WriteWithoutResponse)
        if withoutResponse && !withResponse
        {
            WriteType.selectedSegmentIndex = WRITE_TYPE_COMMAND
            disableSegment(WRITE_TYPE_REQUEST)
        }else if withResponse && !withoutResponse
        {
            WriteType.selectedSegmentIndex = WRITE_TYPE_REQUEST
            disableSegment(WRITE_TYPE_COMMAND)
        }
        else if withoutResponse && withResponse
        {
            WriteType.selectedSegmentIndex = WRITE_TYPE_COMMAND
            enableSegment(WRITE_TYPE_REQUEST)
        }
            
        if isWrittingToDescriptor
        {
            self.WriteType.isHidden = true
            self.WriteTypeLabel.isHidden = true
        }
    }
    
    func disableSegment(_ index: Int)
    {
        WriteType.setEnabled(false, forSegmentAt: index)
    }
    
    func enableSegment(_ index: Int)
    {
        WriteType.setEnabled(true, forSegmentAt: index)
    }
    
    open func textFieldShouldReturn(_ newValueField: UITextField) -> Bool {
        popUpWrapper.writtenValue = getUserInput()
        newValueField.resignFirstResponder()
        return true
    }
    
    @IBAction func WriteTypeSegmentChosen(_ sender: UISegmentedControl) {
        popUpWrapper.writeType = getWriteType()
    }
    
    
    @IBAction func CancelButtonClicked(_ sender: UIButton) {
        dismissPopover()
    }
    
    @IBAction func SendButtonClicked(_ sender: UIButton) {
        popUpWrapper.writtenValue = getUserInput()
        popUpWrapper.writeType = getWriteType()
        if popUpWrapper.isValid()
        {
            writeValuePopoverDelegate?.userInputReady(popUpWrapper)
            dismissPopover()
        }
        else
        {
            NewValueTextField.layer.borderWidth = 1
            NewValueTextField.layer.borderColor = UIColor.red.cgColor
            NewValueTextField.addTarget(self, action: #selector(WriteValuePopoverViewController.newValueTextFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        }
    }
    
    @objc func newValueTextFieldDidChange(_ textField: UITextField)
    {
        NewValueTextField.layer.borderColor = UIColor.clear.cgColor
    }
    
    func dismissPopover()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getUserInput() ->String?
    {
        var userInput: String?
        if let result = NewValueTextField.text
        {
            let data = result.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if data != ""
            {
                userInput = data
            }
        }
        return userInput
    }
    
    func getWriteType() ->CBCharacteristicWriteType
    {
        var chosenType: CBCharacteristicWriteType = .withoutResponse
        switch (self.WriteType.selectedSegmentIndex)
        {
          case 0:
              chosenType = CBCharacteristicWriteType.withoutResponse
              break;
          case 1:
              chosenType = CBCharacteristicWriteType.withResponse
              break;
          default:
              chosenType = CBCharacteristicWriteType.withoutResponse
        }
        return chosenType
    }
}
