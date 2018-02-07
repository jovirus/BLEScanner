//
//  GattDescriptorViewController.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 28/09/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

protocol ValuesFromGattDescriptorViewControllerDelegate
{
    func deviceDisconnectAtDescriptorView(_ device: BLEDevice)
}

class GattDescriptorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate,BLEDeviceManagerDescriptorDelegate, BLEDeviceManagerDeviceConnectionDelegate, WriteValuePopoverDelegate, UITabBarDelegate{
    
    @IBOutlet weak var gattDescriptorTableView: UITableView!
    var selectedCellViewModel: GattDescriptorCellViewModel?
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var deviceConnectionStatus: UILabel!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var logViewButton: UITabBarItem!
    
    var writeValuePopoverController: WriteValuePopoverViewController?
    var gattDescriptorViewModel: GattDescriptorViewModel = GattDescriptorViewModel()
    var valuesFromGattDescriptorViewControllerDelegate: ValuesFromGattDescriptorViewControllerDelegate?
    var logManager: LogManager!
    
    //MARK: prepare for view
    override func viewDidLoad() {
        super.viewDidLoad()
        gattDescriptorTableView.dataSource = self
        gattDescriptorTableView.delegate = self
        gattDescriptorTableView.rowHeight = UITableViewAutomaticDimension
        gattDescriptorTableView.estimatedRowHeight = gattDescriptorViewModel.minHeight
        initialLogVC()
        self.writeValuePopoverController = self.storyboard!.instantiateViewController(withIdentifier: "WriteValuePopoverViewController") as? WriteValuePopoverViewController
        if let writeValuePopoverController = self.writeValuePopoverController {
            writeValuePopoverController.writeValuePopoverDelegate = self
        }
        self.navigationItem.title = GattDescriptorViewModel.DESCRIPTORS
        showStatusBar()
        self.logManager = LogManager.instance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setDelegate()
    }
    
    private func initialLogVC() {
        ((self.revealViewController().rearViewController).childViewControllers.first as! LogViewController).logTableViewModel.setSelectedDevice(self.gattDescriptorViewModel.selectedDevice!, session: self.gattDescriptorViewModel.session)
    }
    
    func showStatusBar() {
        if let device = gattDescriptorViewModel.selectedDevice {
            self.deviceConnectionStatus.text = device.connectionStatus.description()
            self.deviceName.text = device.deviceName
        } else {
            self.deviceConnectionStatus.text = Symbols.NOT_AVAILABLE
            self.deviceName.text = Symbols.NOT_AVAILABLE
        }
    }
    
    func setDelegate() {
        BLEDeviceManager.instance().deviceManagerDescriptorDelegate = self
        BLEDeviceManager.instance().deviceManagerDeviceConnectionDelegate = self
        tabBar.delegate = self
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
            self.revealViewController().revealToggle(item)
            self.tabBar.tintColor = UIColor.gray
        }
    }
    //ENDMARK
    
    //MARKS: Callbacks handling
    func hasDeviceConnectionStatusChanged(isConnected: Bool, updatedDevice: BLEDevice, error: NSError?) {
        logManager.addLog("\(updatedDevice.deviceName) is " + (isConnected == true ? gattDescriptorViewModel.CONNECTION_STATUS_CONNECTED : gattDescriptorViewModel.CONNECTION_STATUS_DISCONNECTED), logType: .info, object: #function, session: gattDescriptorViewModel.session)
        self.gattDescriptorViewModel.setSelectedDevice(updatedDevice)
        if let device = self.gattDescriptorViewModel.selectedDevice
        {
            self.deviceConnectionStatus.text = device.connectionStatus.description()
        }
        controlCellBackgroundWhenConnectionStatusChanged(isConnected)
    }
    
    func controlCellBackgroundWhenConnectionStatusChanged(_ isConnected: Bool)
    {
        if isConnected
        {
            self.gattDescriptorTableView.allowsSelection = true
            self.gattDescriptorViewModel.isDataTimeOut = false
        }
        else
        {
            self.gattDescriptorTableView.allowsSelection = false
            self.gattDescriptorViewModel.isDataTimeOut = true
        }
        self.gattDescriptorTableView.reloadData()
    }
    
    func didUpdateValueDescriptor(_ descriptor: CBDescriptor, error: NSError?)
    {
        if error != nil
        {
            logManager.addLog("Could not update value for descriptor.", logType: .info, object: #function, session: self.gattDescriptorViewModel.session)
        }else
        {
            let uuid = DataConvertHelper.getUUID(descriptor.uuid.data)
            let cellViewModel = self.gattDescriptorViewModel.findCell(uuid)
            if let cellVM = cellViewModel, let row = cellVM.cellIndex
            {
                _ = cellVM.updateDescriptor(descriptor)
                let indexPath = getIndexPath(row)
                let rows = [indexPath]
                let cellView = getCellView(row)
                cellView.DescriptorValue.text = cellVM.Value
                logManager.addLog("\(cellVM.Value) received", logType: .info, object: #function, session: self.gattDescriptorViewModel.session)
                self.gattDescriptorTableView.reloadRows(at: rows, with: UITableViewRowAnimation.fade)
            }
        }
    }
    
    func didWriteValueForDescriptor(_ Descriptor: CBDescriptor, error: NSError?) {
        if let cellVM = getCellViewModel(Descriptor)
        {
            if error != nil
            {
                logManager.addLog("Could not write value for descriptor \(cellVM.Name)", logType: .info, object: #function, session: self.gattDescriptorViewModel.session)
            } else
            {
                if let newData = Descriptor.value
                {
                    logManager.addLog(DataHandelingMessage.newData.description + Symbols.whiteSpace + DataConvertHelper.getDescriptorValue(newData as AnyObject?), logType: .info, object: #function, session: self.gattDescriptorViewModel.session)
                } else
                {
                    logManager.addLog(DataHandelingMessage.nilData.description, logType: .info, object: #function, session: self.gattDescriptorViewModel.session)
                }
            }
        }
    }

    func userInputReady(_ value: WrittenValueWrapper)
    {
        if let cell = self.selectedCellViewModel
        {
            logManager.addLog("Writing command to descriptor. \(cell.Name)", logType: .verbose, object: #function, session: self.gattDescriptorViewModel.session)
            if let userInput = value.writtenValue, let buffer = DataConvertHelper.toData(userInput), let toDevice = self.gattDescriptorViewModel.selectedDevice?.cBPeripheral, let cellVM = self.selectedCellViewModel, let toDescriptor = cellVM.cbDescriptor
            {
                if !GattDescriptorUUID.isClientCharacteristicConfiguration(cellVM.UUID)
                {
                    logManager.addLog(DataHandelingMessage.convertedData.description + Symbols.whiteSpace + userInput + Symbols.to + String(describing: buffer), logType: .application, object: #function, session: self.gattDescriptorViewModel.session)
                    BLEDeviceManager.instance().writeDescriptor(toDevice, data: buffer, descriptor: toDescriptor)
                }
                else
                {
                    logManager.addLog(DataHandelingMessage.errorOccursConverting.description, logType: .warning, object: #function, session: self.gattDescriptorViewModel.session)
                }
            }
        }
    }
    //ENDMARK

    //MARK Button setup
    @IBAction func SendValueButtonClicked(_ sender: UIButton) {
        getSelectedCellViewModel(sender.tag)
        if let writeValuePopoverController = self.writeValuePopoverController
        {
            writeValuePopoverController.modalPresentationStyle = .popover
            writeValuePopoverController.preferredContentSize = CGSize(width: 300, height: 150)
            writeValuePopoverController.isWrittingToDescriptor = true
            let popoverWriteValueCharacteristic = writeValuePopoverController.popoverPresentationController
            popoverWriteValueCharacteristic?.permittedArrowDirections = .any
            popoverWriteValueCharacteristic?.delegate = self
            popoverWriteValueCharacteristic?.sourceView = sender
            popoverWriteValueCharacteristic?.sourceRect = CGRect(x: sender.bounds.midX , y: sender.bounds.midY, width: 1, height: 1)
            self.present(writeValuePopoverController, animated: true, completion: nil)
        }
    }
    
    @IBAction func ReadDescriptorButtonClicked(_ sender: UIButton) {
        getSelectedCellViewModel(sender.tag)
        if let device = gattDescriptorViewModel.selectedDevice, let cellVM = self.selectedCellViewModel, let toDescriptor = cellVM.cbDescriptor
        {
            BLEDeviceManager.instance().readDescriptorValue(device.cBPeripheral, descriptor: toDescriptor)
        }
    }
    
    //MARK table view handling
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func getCellDescriptorTableView(_ indexPath: IndexPath) -> GattDescriptorTableViewCell
    {
        let cell: GattDescriptorTableViewCell = gattDescriptorTableView.dequeueReusableCell(withIdentifier: "GattDescriptorTableViewCell", for: indexPath) as! GattDescriptorTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gattDescriptorViewModel.listOfGattDescriptorViewCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GattDescriptorTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GattDescriptorTableViewCell", for: indexPath) as! GattDescriptorTableViewCell
        let row = (indexPath as NSIndexPath).row
        let cellVM = self.gattDescriptorViewModel.listOfGattDescriptorViewCell[row]
        cell.ReadValueButton.tag = row
        cell.SendValueButton.tag = row
        visibilityControlButtons(cell, uuid: cellVM.UUID)
        cell.DescriptorValue.text = cellVM.Value
        cell.DescriptorUuid.text = cellVM.getUUID();
        cell.DescriptorName.text = cellVM.Name
        setCellBackground(cell, isTimeOut: self.gattDescriptorViewModel.isDataTimeOut)
        return cell
    }
    
    func setCellBackground(_ cell: GattDescriptorTableViewCell, isTimeOut: Bool)
    {
        if isTimeOut
        {
            let grayColor = UIColor(red: (147/255.0), green: (149/255.0), blue: (151/255.0), alpha: 1)
            cell.DescriptorName.textColor = grayColor
            cell.ReadValueButton.isHidden = true
            cell.SendValueButton.isHidden = true
        }
        else
        {
            let blackGray = UIColor.black
            cell.DescriptorName.textColor = blackGray
            cell.ReadValueButton.isHidden = false
            cell.SendValueButton.isHidden = false
        }
    }
    
    func visibilityControlButtons(_ cell: GattDescriptorTableViewCell, uuid: CBUUID)
    {
        if GattDescriptorUUID.isClientCharacteristicConfiguration(uuid)
        {
            cell.WriteValueButtonWidth.constant = 0;
        }
        else
        {
            cell.WriteValueButtonWidth.constant = 40
        }
    }
    //ENDMARK
    
    //MARKS: Helpers
    func getSelectedCellViewModel(_ index: Int)
    {
        let result = self.gattDescriptorViewModel.listOfGattDescriptorViewCell[index]
        self.selectedCellViewModel = result
    }
    
    func getCellViewModel(_ descriptor: CBDescriptor) -> GattDescriptorCellViewModel!
    {
        let uuid = DataConvertHelper.getUUID(descriptor.uuid.data)
        let cellViewModel = self.gattDescriptorViewModel.findCell(uuid)
        return cellViewModel
    }
    
    func getCellView(_ cellIndex: Int) -> GattDescriptorTableViewCell
    {
        let indexPath = getIndexPath(cellIndex)
        let cell: GattDescriptorTableViewCell = gattDescriptorTableView.cellForRow(at: indexPath) as! GattDescriptorTableViewCell
        return cell
    }
    
    func getIndexPath(_ cellIndex: Int) ->IndexPath
    {
        let indexPath = IndexPath(row: cellIndex, section: 0)
        return indexPath
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let device = self.gattDescriptorViewModel.selectedDevice , device.cBPeripheral.state == CBPeripheralState.disconnected
        {
            self.valuesFromGattDescriptorViewControllerDelegate!.deviceDisconnectAtDescriptorView(device)
        }
    }
    
    func PrepareForGattDescriptorViewModel(_ characteristic: CBCharacteristic) -> [GattDescriptorCellViewModel]
    {
        if let descriptors = characteristic.descriptors
        {
            for row in 0 ..< descriptors.count
            {
                let newItem = GattDescriptorCellViewModel()
                _ = newItem.updateDescriptor(descriptors[row])
                newItem.AssignCellIndex(row)
                self.gattDescriptorViewModel.listOfGattDescriptorViewCell.append(newItem)
            }
        }
        return self.gattDescriptorViewModel.listOfGattDescriptorViewCell
    }
    //ENDMARK
}

