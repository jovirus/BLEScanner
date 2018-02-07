//
//  GattCharacteristicViewController.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 14/09/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

protocol ValuesFromGattCharacteristicViewControllerDelegate
{
    func deviceDisconnectAtCharacteristicView(_ device: BLEDevice)
}

class GattCharacteristicViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, WriteValuePopoverDelegate, BLEDeviceManagerDeviceConnectionDelegate, BLEDeviceManagerCharacteristicDelegate, ValuesFromGattDescriptorViewControllerDelegate,UITabBarDelegate {
    
    var selectedCell: GattCharacteristicCellViewModel?
    var characteristicViewModel = GattCharacteristicViewModel()
    var writeValuePopoverController: WriteValuePopoverViewController?
    var valuesFromGattCharacteristicViewControllerDelegate: ValuesFromGattCharacteristicViewControllerDelegate!
    
    var logManager: LogManager!
    
    @IBOutlet var gattCharacteristicTableView: UITableView!
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var deviceConnectionStatus: UILabel!
    @IBOutlet weak var logViewButton: UITabBarItem!
    @IBOutlet weak var tabBar: UITabBar!
    
    // MARK: Caches on client site
    fileprivate var userChoices = Dictionary<Int, UserChoice>()
    fileprivate class UserChoice {
        var cellID: Int
        var isNotificationOrIndicationOn: Bool = false
        var clickedButtonType = ClientCharacteristicConfigurationEnum.notInUsed
        
        init(cellID: Int, buttonType: ClientCharacteristicConfigurationEnum)
        {
            self.cellID = cellID
            self.clickedButtonType = buttonType
        }
    }
    
    fileprivate func findUserChoice(_ cellID: Int) -> UserChoice!
    {
        var userChoice: UserChoice?
        let result = self.userChoices.filter({ (key, value) in key == cellID }).first
        if let (_, value) = result
        {
             userChoice = value
        }
        return userChoice
    }
    
    fileprivate func closeAnyNotificationOrIndicationOn()
    {
        for (_, var value) in self.userChoices
        {
            if value.isNotificationOrIndicationOn
            {
                let cellView = getCellView(value.cellID)
                switch value.clickedButtonType {
                    case  .indications:
                        indicationSwitch(cellView.StartIndicationButton, userChoice: &value)
                        break
                    case .notifications:
                        notificationSwitch(cellView.StartNotificationButton, userChoice: &value)
                        break
                    default:
                        break
                }
            }
        }
    }
    //ENDMARK
    
    //MARK: view control preparation
    override func viewDidLoad() {
        super.viewDidLoad()
        gattCharacteristicTableView.dataSource = self
        gattCharacteristicTableView.delegate = self
        gattCharacteristicTableView.rowHeight = UITableViewAutomaticDimension
        gattCharacteristicTableView.estimatedRowHeight = characteristicViewModel.minHeight
        initialLogVC()
        initializePopoverController()
        showStatusBar()
        self.logManager = LogManager.instance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setDelegate()
    }
    
    func setDelegate()
    {
        BLEDeviceManager.instance().deviceManagerCharacteristicDelegate = self
        BLEDeviceManager.instance().deviceManagerDeviceConnectionDelegate = self
        tabBar.delegate = self
    }
    
    private func initialLogVC() {
        ((self.revealViewController().rearViewController).childViewControllers.first as! LogViewController).logTableViewModel.setSelectedDevice(self.characteristicViewModel.selectedDevice!, session: self.characteristicViewModel.session)
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0
        {
            self.revealViewController().revealToggle(item)
            self.tabBar.tintColor = UIColor.gray
        }
    }
    
    func initializePopoverController()
    {
        self.writeValuePopoverController = self.storyboard!.instantiateViewController(withIdentifier: "WriteValuePopoverViewController") as? WriteValuePopoverViewController
        if let writeValuePopoverController = self.writeValuePopoverController
        {
            writeValuePopoverController.writeValuePopoverDelegate = self
        }
    }
    
    func showStatusBar()
    {
        if let device = characteristicViewModel.selectedDevice
        {
            self.deviceConnectionStatus.text = device.connectionStatus.description()
            self.deviceName.text = device.deviceName
        }
        else
        {
            self.deviceConnectionStatus.text = Symbols.NOT_AVAILABLE
            self.deviceName.text = Symbols.NOT_AVAILABLE
        }
        self.navigationItem.title = characteristicViewModel.CHARACTERISTICS
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let device = self.characteristicViewModel.selectedDevice , device.cBPeripheral.state == CBPeripheralState.disconnected
        {
            self.valuesFromGattCharacteristicViewControllerDelegate.deviceDisconnectAtCharacteristicView(device)
        }
        if self.isMovingFromParentViewController
        {
            closeAnyNotificationOrIndicationOn()
        }
    }
    //ENDMARK
    
    //MARK Connection GUI control
    func controlCellBackgroundWhenConnectionStatusChanged(_ isConnected: Bool)
    {
        if isConnected
        {
            self.gattCharacteristicTableView.allowsSelection = true
            self.characteristicViewModel.isDataTimeOut = false
        }
        else
        {
            self.gattCharacteristicTableView.allowsSelection = false
            self.characteristicViewModel.isDataTimeOut = true
        }
        self.gattCharacteristicTableView.reloadData()
    }
    //ENDMARK
    
    //MARK handling Callbacks
    func hasDeviceConnectionStatusChanged(isConnected: Bool, updatedDevice: BLEDevice, error: NSError?) {
        logManager.addLog(updatedDevice.deviceName + " is " + (isConnected == true ? BLEConnectStatus.connected.description() : BLEConnectStatus.disconnected.description()), logType: .info, object: #function, session: characteristicViewModel.session)
        self.deviceConnectionStatus.text = updatedDevice.connectionStatus.description()
        self.characteristicViewModel.setSelectedDevice(updatedDevice)
        controlCellBackgroundWhenConnectionStatusChanged(isConnected)
    }
    
    func deviceDisconnectAtDescriptorView(_ device: BLEDevice) {
        hasDeviceConnectionStatusChanged(isConnected: false, updatedDevice: device, error: nil)
        setDelegate()
    }
    
    func didUpdateValueForCharacteristic(_ characteristic: CBCharacteristic, error: NSError?)
    {
        if error != nil
        {
            logManager.addLog("Could not update value for charact.", logType: .info, object: #function, session: characteristicViewModel.session!)
        }
        else if let cellVM = getCellViewModel(characteristic), let row = cellVM.cellIndex
        {
            _ = cellVM.updateChacteristic(characteristic, cellViewID: row)
            let indexPath = getIndexPath(row)
//            let rows = [indexPath]
            logManager.addLog(cellVM.Value + " received ", logType: .info, object: #function, session: characteristicViewModel.session)
//            guard gattCharacteristicTableView.visibleCells.startIndex...gattCharacteristicTableView.visibleCells.endIndex ~= indexPath.row else {
//                return
//            }
            guard let cell = gattCharacteristicTableView.cellForRow(at: indexPath) as? GattCharacteristicTableViewCell else {
                return
            }
//            let cell = gattCharacteristicTableView[row]
            cell.CharacteristicProperty.text = cellVM.getPropertyDescription()
            cell.characteristicValueLabel.text = cellVM.Value
            cell.HasDescriptorLabel.text = String(cellVM.HasDescriptor)
//            DispatchQueue.main.sync{
//                self.gattCharacteristicTableView.beginUpdates()
//                self.gattCharacteristicTableView.reloadRows(at: rows, with: UITableViewRowAnimation.automatic)
//                self.gattCharacteristicTableView.endUpdates()
//            }
        }
    }
    
    
    
    func didWriteValueForCharacteristic(_ characteristic: CBCharacteristic, error: NSError?) {
        guard let _ = getCellViewModel(characteristic) else { return }
        if error != nil {
            logManager.addLog("Could not write value for charact.", logType: .info, object: #function, session: characteristicViewModel.session)
        } else {
            if let newData = characteristic.value {
                logManager.addLog(DataHandelingMessage.newData.description + Symbols.whiteSpace + DataConvertHelper.getNSData(newData), logType: .info, object: #function, session: characteristicViewModel.session!)
            } else {
                logManager.addLog(DataHandelingMessage.nilData.description, logType: .info, object: #function, session: characteristicViewModel.session!)
            }
        }
    }
    
    func getCellViewModel(_ characteristic: CBCharacteristic) -> GattCharacteristicCellViewModel! {
        let uuid = DataConvertHelper.getUUID(characteristic.uuid.data)
        let cellViewModel = self.characteristicViewModel.findCell(uuid)
        return cellViewModel
    }
    
    func getCellView(_ cellIndex: Int) ->GattCharacteristicTableViewCell {
        let indexPath = getIndexPath(cellIndex)
        let cell: GattCharacteristicTableViewCell = self.gattCharacteristicTableView.cellForRow(at: indexPath) as! GattCharacteristicTableViewCell
        return cell
    }
    
    func getIndexPath(_ cellIndex: Int) ->IndexPath {
        let indexPath = IndexPath(row: cellIndex, section: 0)
        return indexPath
    }
    
    func userInputReady(_ value: WrittenValueWrapper) {
        guard let cell = self.selectedCell else { return }
        if let userInput = value.writtenValue, let buffer = DataConvertHelper.toData(userInput), let toDevice = self.characteristicViewModel.selectedDevice, let toCharact = cell.cbCharacteristic, let writeType = value.writeType {
            logManager.addLog(DataHandelingMessage.convertedData.description + Symbols.whiteSpace + userInput + Symbols.to + String(describing: buffer), logType: .application, object: #function, session: characteristicViewModel.session!)
            BLEDeviceManager.instance().writeCharacteristic(toDevice.cBPeripheral, data: buffer, characteristic: toCharact, type: writeType)
        } else {
            logManager.addLog(DataHandelingMessage.errorOccursConverting.description, logType: .warning, object: #function, session: characteristicViewModel.session)
        }
    }
    
    @IBAction func WriteCharacteristicButtonClicked(_ sender: UIButton) {
        guard let writeValuePopoverController = self.writeValuePopoverController else { return }
        writeValuePopoverController.modalPresentationStyle = .popover
        writeValuePopoverController.preferredContentSize = CGSize(width: 250, height: 200)
        getSelectedCellViewModel(sender.tag)
            if let cell = self.selectedCell {
                writeValuePopoverController.operationProperties = cell.Properties
            }
        let popoverWriteValueCharacteristic = writeValuePopoverController.popoverPresentationController
        popoverWriteValueCharacteristic?.permittedArrowDirections = .any
        popoverWriteValueCharacteristic?.delegate = self
        popoverWriteValueCharacteristic?.sourceView = sender
        self.present(writeValuePopoverController, animated: true, completion: nil)
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    @IBAction func NotificationButtonClicked(_ sender: UIButton) {
        getSelectedCellViewModel(sender.tag)
        guard let cellVM = self.selectedCell , cellVM.cellIndex != nil else { return }
        let id = cellVM.cellIndex!
        if var userChoice = findUserChoice(id) {
            notificationSwitch(sender, userChoice: &userChoice)
        } else {
            var userChoice = UserChoice(cellID: id, buttonType: ClientCharacteristicConfigurationEnum.notifications)
            self.userChoices[id] = userChoice
            notificationSwitch(sender, userChoice: &userChoice)
        }
    }
    
    fileprivate func notificationSwitch(_ sender: UIButton, userChoice: inout UserChoice) {
        logManager.addLog("Turning notification \(userChoice.isNotificationOrIndicationOn == true ? "off" : "on")", logType: .verbose, object: #function, session: characteristicViewModel.session!)
        if userChoice.isNotificationOrIndicationOn {
            turnOnOffNotificationOrIndication(sender.tag, onOffSwitch: false)
            setImage("ic_operation_start_notifications_normal", button: sender, state: UIControlState())
            userChoice.isNotificationOrIndicationOn = false
        }
        else {
            turnOnOffNotificationOrIndication(sender.tag, onOffSwitch: true)
            setImage("ic_operation_stop_notifications_normal", button: sender, state: UIControlState())
            userChoice.isNotificationOrIndicationOn = true
        }
    }
    
    @IBAction func IndicationButtonClicked(_ sender: UIButton) {
        getSelectedCellViewModel(sender.tag)
        guard let cellVM = self.selectedCell , cellVM.cellIndex != nil else { return }
        let id = cellVM.cellIndex!
        if var userChoice = findUserChoice(id) {
           indicationSwitch(sender, userChoice: &userChoice)
        } else {
            var userChoice = UserChoice(cellID: id, buttonType: ClientCharacteristicConfigurationEnum.indications)
            self.userChoices[id] = userChoice
            indicationSwitch(sender, userChoice: &userChoice)
        }
    }
    
    fileprivate func indicationSwitch(_ sender: UIButton, userChoice: inout UserChoice) {
        logManager.addLog("Turning indication \(userChoice.isNotificationOrIndicationOn == true ? "off" : "on")", logType: .verbose, object: #function, session: characteristicViewModel.session!)
        if userChoice.isNotificationOrIndicationOn {
            turnOnOffNotificationOrIndication(sender.tag, onOffSwitch: false)
            setImage("ic_operation_start_indications_normal", button: sender, state: UIControlState())
            userChoice.isNotificationOrIndicationOn = false
        } else {
            turnOnOffNotificationOrIndication(sender.tag, onOffSwitch: true)
            setImage("ic_operation_stop_indications_normal", button: sender, state: UIControlState())
            userChoice.isNotificationOrIndicationOn = true
        }
    }

    
    func turnOnOffNotificationOrIndication(_ cellIndex: Int, onOffSwitch: Bool) {
        getSelectedCellViewModel(cellIndex)
        guard let device = self.characteristicViewModel.selectedDevice, let cellVM = self.selectedCell, let character = cellVM.cbCharacteristic else { return }
        BLEDeviceManager.instance().setNotification(device.cBPeripheral, isOn: onOffSwitch , characteristic: character)
    }

    
    @IBAction func ReadCharacteristicButtonClicked(_ sender: UIButton) {
        let identifier = sender.tag
        getSelectedCellViewModel(identifier)
        setImage("ic_operation_read_pressed", button: sender, state: .highlighted)
        readCharacteristic()
    }
    
    func readCharacteristic() {
        guard let cellVM = self.selectedCell, let characteristic = cellVM.cbCharacteristic, let device = characteristicViewModel.selectedDevice else { return }
        BLEDeviceManager.instance().readCharacteristicValue(device.cBPeripheral, characteristic: characteristic)
    }
    
    func setImage(_ name: String, button: UIButton, state: UIControlState) {
        let image = UIImage(named: name) as UIImage?
        button.setImage(image, for: state)
    }
    
    func getSelectedCellViewModel(_ index: Int) {
        self.selectedCell = characteristicViewModel.listOfGattCharacteristicViewCell[index]
    }
    //ENDMARK
    
    //MARK: prepare for descriptor view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDescriptors" {
            let selectedRow = (gattCharacteristicTableView.indexPathForSelectedRow as NSIndexPath?)?.row
            let destinationViewController = segue.destination as! GattDescriptorViewController
            if let row = selectedRow {
                let result = characteristicViewModel.listOfGattCharacteristicViewCell[row]
                if let characts = result.cbCharacteristic {
                    _ = destinationViewController.PrepareForGattDescriptorViewModel(characts)
                    destinationViewController.gattDescriptorViewModel.selectedCharacteristic = characts
                }
            }
            destinationViewController.gattDescriptorViewModel.selectedService = characteristicViewModel.selectedService
            destinationViewController.gattDescriptorViewModel.setSelectedDevice(characteristicViewModel.selectedDevice!, session: characteristicViewModel.session!)
            destinationViewController.valuesFromGattDescriptorViewControllerDelegate = self
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
       var shouldPerformSegue: Bool = false
       let indexPath: IndexPath = gattCharacteristicTableView.indexPathForSelectedRow!
       getSelectedCellViewModel((indexPath as NSIndexPath).row)
        guard let cell = self.selectedCell, let cbCharact = cell.cbCharacteristic, let descriptor = cbCharact.descriptors else { return shouldPerformSegue }
        guard descriptor.count != 0 else { return shouldPerformSegue }
        shouldPerformSegue = true
        return shouldPerformSegue
    }
    
    static func PrepareForGattCharacteristicViewModel(_ service: CBService) -> [GattCharacteristicCellViewModel] {
        var listOfCharacts: [GattCharacteristicCellViewModel] = []
        guard let characts = service.characteristics else { return listOfCharacts }
        for row in 0 ..< characts.count {
            let newItem = GattCharacteristicCellViewModel()
            _ = newItem.updateChacteristic(characts[row], cellViewID: row)
            listOfCharacts.append(newItem)
        }
        return listOfCharacts
    }
    //ENDMARK
    
    //MARK: - Table control
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.characteristicViewModel.listOfGattCharacteristicViewCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GattCharacteristicTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GattCharacteristicTableViewCell", for: indexPath) as! GattCharacteristicTableViewCell
        let row = (indexPath as NSIndexPath).row
        let cellViewModel = self.characteristicViewModel.listOfGattCharacteristicViewCell[row]
        cell.characteristicValueLabel.text = cellViewModel.Value
        cell.CharacteristicName.text = cellViewModel.Name
        cell.CharacteristicUUID.text = cellViewModel.getUUID()!
        visibilityControlButtons(cell, cellVM: cellViewModel)
        cellViewModel.hasBeenInitialized = true
        cell.CharacteristicProperty.text = cellViewModel.getPropertyDescription()
        cell.ReadCharacteristicButton.tag = row
        cell.WriteCharacteristicButton.tag = row
        cell.StartNotificationButton.tag = row
        cell.StartIndicationButton.tag = row
        cell.HasDescriptorLabel.text = String(cellViewModel.HasDescriptor)
        setCellBackground(cell, isTimeOut: self.characteristicViewModel.isDataTimeOut)
        return cell;
    }
    
    func setCellBackground(_ cell: GattCharacteristicTableViewCell, isTimeOut: Bool) {
        if isTimeOut {
            let grayColor = UIColor(red: (147/255.0), green: (149/255.0), blue: (151/255.0), alpha: 1)
            cell.CharacteristicName.textColor = grayColor
            cell.ReadCharacteristicButton.isHidden = true
            cell.WriteCharacteristicButton.isHidden = true
            cell.StartIndicationButton.isHidden = true
            cell.StartNotificationButton.isHidden = true
        } else {
            let blackColor = UIColor.black
            cell.CharacteristicName.textColor = blackColor
            cell.ReadCharacteristicButton.isHidden = false
            cell.WriteCharacteristicButton.isHidden = false
            cell.StartIndicationButton.isHidden = false
            cell.StartNotificationButton.isHidden = false
        }
    }
    
    func visibilityControlButtons(_ cellView: GattCharacteristicTableViewCell, cellVM: GattCharacteristicCellViewModel) {
        let propertiesList = cellVM.Properties
        if propertiesList.contains("Write") || propertiesList.contains("WriteWithoutResponse")
        {
            cellView.WriteCharacteristicButtonWidth.constant = 40
        }
        else if !propertiesList.contains("Write") && !propertiesList.contains("WriteWithoutResponse")
        {
            cellView.WriteCharacteristicButtonWidth.constant = 0
        }
        if !propertiesList.contains("Read")
        {
            cellView.ReadCharacteristicButtonWidth.constant = 0
        }
        else if propertiesList.contains("Read")
        {
            cellView.ReadCharacteristicButtonWidth.constant = 40
        }
        if !propertiesList.contains("Indicate")
        {
            cellView.StartIndicationButtonWidth.constant = 0
        } else if propertiesList.contains("Indicate") {
            cellView.StartIndicationButtonWidth.constant = 40
            if let userChoice = findUserChoice(cellVM.cellIndex!) , userChoice.isNotificationOrIndicationOn == true
            {
                setImage("ic_operation_stop_indications_normal", button: cellView.StartIndicationButton, state: UIControlState())
            } else {
                setImage("ic_operation_start_indications_normal", button: cellView.StartIndicationButton, state: UIControlState())
            }
        }

        if !propertiesList.contains("Notify") {
            cellView.StartNotificationButtonWidth.constant = 0
        }
        else if propertiesList.contains("Notify") {
            cellView.StartNotificationButtonWidth.constant = 40
            if let userChoice = findUserChoice(cellVM.cellIndex!) , userChoice.isNotificationOrIndicationOn == true
            {
                setImage("ic_operation_stop_notifications_normal", button: cellView.StartNotificationButton, state: UIControlState())
            }else
            {
                setImage("ic_operation_start_notifications_normal", button: cellView.StartNotificationButton, state: UIControlState())
            }
        }
    }
    //ENDMARK
}
