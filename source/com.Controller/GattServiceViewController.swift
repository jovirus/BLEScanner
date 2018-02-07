//
//  FramPageViewController.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 02/10/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class GattServiceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ValuesFromGattCharacteristicViewControllerDelegate, BLEDeviceManagerDeviceConnectionDelegate, BLEDeviceManagerGattServiceDiscoveriedDelegate, UITabBarDelegate  {
    
    fileprivate(set) var shouldEnablePanGuesture: Bool = true

    @IBOutlet weak var gattServicesTableView: UITableView!
    @IBOutlet weak var deviceConnectionStatus: UILabel!
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var gattServiceDiscoveryIndicator: UIActivityIndicatorView!
    @IBOutlet weak var connectionControlButton: UIBarButtonItem!
    @IBOutlet weak var tabBar: UITabBar!
    
    fileprivate(set) var gattServiceViewModel = GattServiceViewModel()
    fileprivate var shouldDisconnectOnDisappear: Bool = true
    
    //MARK: - View Preparation
    override func viewDidLoad() {
        guard self.revealViewController() != nil else{
            return
        }
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        initialLogVC()
        //DFUViewButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareLoadingData()
        setDelegate()
        self.shouldDisconnectOnDisappear = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard gattServiceViewModel.selectedDevice != nil && shouldDisconnectOnDisappear else{
            return
        }
        gattServiceViewModel.closeSession()
    }
    
    func prepareLoadingData() {
        if let value = self.gattServiceViewModel.isInitialized , value == true
        {
            return
        }
        else {
            connectSelectedDevice()
            showConnecting()
            gattServicesTableView.rowHeight = UITableViewAutomaticDimension
            gattServicesTableView.estimatedRowHeight = gattServiceViewModel.estimatedRowHeight
            gattServiceViewModel.isInitialized = true
        }
    }
    
    func setDelegate()
    {
        BLEDeviceManager.instance().deviceManagerDeviceConnectionDelegate = self
        BLEDeviceManager.instance().deviceManagerGattServiceDiscoveriedDelegate = self
        gattServicesTableView.dataSource = self
        gattServicesTableView.delegate = self
        self.tabBar.delegate = self
    }
    
    private func initialLogVC() {
        ((self.revealViewController().rearViewController).childViewControllers.first as! LogViewController).logTableViewModel.setSelectedDevice(self.gattServiceViewModel.selectedDevice, session: self.gattServiceViewModel.session)
    }
    
    //MARK: - Connection status change
    private func showConnecting() {
        gattServiceViewModel.phoneStatusOnPeripheral = BLEConnectStatus.connecting
        self.deviceConnectionStatus.text = gattServiceViewModel.CONNECTION_STATUS_CONNECTING
        self.connectionControlButton.title = GattServiceViewModel.ConnectButtonStatus.cancelConnection.description()
        if let device = gattServiceViewModel.selectedDevice {
            self.deviceName.text = device.deviceName
        }
    }
    
    private func showDisconnecting() {
        gattServiceViewModel.phoneStatusOnPeripheral = BLEConnectStatus.disconnecting
        self.deviceConnectionStatus.text = gattServiceViewModel.CONNECTION_STATUS_DISCONNECTING
        self.connectionControlButton.title = gattServiceViewModel.CONNECTION_STATUS_DISCONNECTING
        if let device = gattServiceViewModel.selectedDevice {
            self.deviceName.text = device.deviceName
        }
    }
    
    private func showConnected() {
        gattServiceViewModel.phoneStatusOnPeripheral = BLEConnectStatus.connected
        self.deviceConnectionStatus.text = gattServiceViewModel.CONNECTION_STATUS_CONNECTED
        self.connectionControlButton.title = GattServiceViewModel.ConnectButtonStatus.disconnect.description()
        if let device = gattServiceViewModel.selectedDevice
        {
            self.deviceName.text = device.deviceName
        }
    }
    
    private func showDisconnected() {
        gattServiceViewModel.phoneStatusOnPeripheral = BLEConnectStatus.disconnected
        self.deviceConnectionStatus.text = gattServiceViewModel.CONNECTION_STATUS_DISCONNECTED
        self.connectionControlButton.title = GattServiceViewModel.ConnectButtonStatus.connect.description()
        if let device = gattServiceViewModel.selectedDevice
        {
            self.deviceName.text = device.deviceName
        }
    }
    
    private func connectSelectedDevice() {
        if let toDevice = self.gattServiceViewModel.selectedDevice
        {
            gattServiceViewModel.logManager.addLog(gattServiceViewModel.CONNECTION_STATUS_CONNECTING + " \(toDevice.deviceName)", logType: .verbose, object: toDevice.deviceName, session: self.gattServiceViewModel.session)
            BLEDeviceManager.instance().connectPeriphral(BLEDeviceManager.instance().centralManager, peripheral: toDevice.cBPeripheral)
            indicatorControl(shouldStart: true)
        }
    }
    
    private func disconnectSelectedDevice() {
        if let toDevice = self.gattServiceViewModel.selectedDevice
        {
            gattServiceViewModel.logManager.addLog( gattServiceViewModel.CONNECTION_STATUS_DISCONNECTING + " \(toDevice.deviceName)", logType: .verbose, object: toDevice.deviceName, session: self.gattServiceViewModel.session)
            BLEDeviceManager.instance().disconnectPeriphral(BLEDeviceManager.instance().centralManager, peripheral: toDevice.cBPeripheral)
            indicatorControl(shouldStart: true)
        }
    }
    
    @IBAction func connectionControlButtonClicked(_ sender: AnyObject) {
        connectionControlPeriphral()
    }
    
   fileprivate func controlCellBackgroundWhenConnectionStatusChanged(_ isConnected: Bool) {
        if isConnected
        {
            gattServicesTableView.allowsSelection = true
            gattServiceViewModel.isDataTimeOut = false
        }
        else
        {
            gattServicesTableView.allowsSelection = false
            gattServiceViewModel.isDataTimeOut = true
        }
        gattServicesTableView.reloadData()
    }
    
//    private func controlTabBarWhenConnectionStatusChanged(_ isConnected: Bool) {
//        if isConnected
//        {
//            //self.tabBar.isUserInteractionEnabled = true
//            //self.LogViewButton.isEnabled = true
//            //if self.gattServiceViewModel.shouldShowDFUButton() {
//            //    self.DFUViewButton.isEnabled = true
//            //}
//        }
//        else
//        {
//            //self.tabBar.isUserInteractionEnabled = false
//            //self.LogViewButton.isEnabled = false
//            //self.DFUViewButton.isEnabled = false
//        }
//    }
    
    
    fileprivate func connectionControlPeriphral() {
//        var isConnected = false
        guard let device = gattServiceViewModel.selectedDevice else {
            return
        }
        if device.cBPeripheral.state == CBPeripheralState.connected && self.connectionControlButton.title == GattServiceViewModel.ConnectButtonStatus.disconnect.description() {
            disconnectSelectedDevice()
            showDisconnecting()
//            isConnected = false
        }
        else if device.cBPeripheral.state == CBPeripheralState.disconnected && self.connectionControlButton.title == GattServiceViewModel.ConnectButtonStatus.connect.description() {
            connectSelectedDevice()
            showConnecting()
            indicatorControl(shouldStart: true)
        }
        else if device.cBPeripheral.state == CBPeripheralState.connected && self.connectionControlButton.title == GattServiceViewModel.ConnectButtonStatus.connect.description() {
        
        }
        else if device.cBPeripheral.state == CBPeripheralState.connecting && self.connectionControlButton.title == GattServiceViewModel.ConnectButtonStatus.cancelConnection.description() {
            disconnectSelectedDevice()
            showDisconnecting()
//            isConnected = false
        }
//        controlCellBackgroundWhenConnectionStatusChanged(isConnected)
//        controlTabBarWhenConnectionStatusChanged(isConnected)
    }
    
    fileprivate func indicatorControl(shouldStart: Bool) {
        if shouldStart {
            self.gattServiceDiscoveryIndicator.isHidden = false
            self.gattServiceDiscoveryIndicator.startAnimating()
        }
        else {
            self.gattServiceDiscoveryIndicator.isHidden = true
            self.gattServiceDiscoveryIndicator.stopAnimating()
        }
    }
    
    //MARK: - Tabbar control
//    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        /** tag 0 is Log view refers in storyboard
//         tag 1 is DFU view refers in the storyboard
//         */
//        if item.tag == 0
//        {
//            self.shouldDisconnectOnDisappear = false
//            self.revealViewController().revealToggle(item)
//            self.tabBar.tintColor = UIColor.gray
//        } else if item.tag == 1 {
//            // open the dfu pages.
//            let dfuFirmwareMainVC = self.storyboard?.instantiateViewController(withIdentifier: "DFUMainViewViewController") as? DFUMainViewViewController
//            dfuFirmwareMainVC?.dfuMainViewModel = DFUMainViewModel(centralMananger: BLEDeviceManager.instance().centralManager , peripheral: self.gattServiceViewModel.selectedDevice.cBPeripheral, device: gattServiceViewModel.selectedDevice, session: gattServiceViewModel.session)
//            self.present(dfuFirmwareMainVC!, animated: true)
//            self.tabBar.tintColor = UIColor.gray
//        }
//    }
    
    @IBAction func DFUViewButtonPressed(_ sender: UIButton) {
        let dfuFirmwareMainVC = self.storyboard?.instantiateViewController(withIdentifier: "DFUMainNavigationController") as? DFUMainNavigationController
        dfuFirmwareMainVC?.dfuMainViewModel = DFUMainViewModel(centralMananger: BLEDeviceManager.instance().centralManager , peripheral: self.gattServiceViewModel.selectedDevice.cBPeripheral, device: gattServiceViewModel.selectedDevice, session: gattServiceViewModel.session)
        self.present(dfuFirmwareMainVC!, animated: true)
        self.tabBar.tintColor = UIColor.gray
    }
    
    
    // MMARK: ServiceTable configuration
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gattServiceViewModel.listOfGattServiceViewCell.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GattServiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GattServiceTableViewCell", for: indexPath) as! GattServiceTableViewCell
        let row = (indexPath as NSIndexPath).row
        let cellVM = self.gattServiceViewModel.listOfGattServiceViewCell[row]
        cell.serviceName.text = cellVM.Name
        cell.uuid.text = cellVM.getUUID()
        cell.primary.text = cellVM.PrimaryService
        if cellVM.isDFUService() {
            cell.imageUIViewWidthConstrain.constant = cell.imageUIViewWidthConstrainDefault
            cell.dfuButtonBackgroundView.layer.cornerRadius = 0.1*cell.DFUViewButton.bounds.size.width
            cell.dfuButtonBackgroundView.clipsToBounds = true
        } else {
            cell.imageUIViewWidthConstrain.constant = 0
        }
        setCellBackground(cell, isTimeOut: self.gattServiceViewModel.isDataTimeOut)
        return cell;
    }
    
    func setCellBackground(_ cell: GattServiceTableViewCell, isTimeOut: Bool) {
        if isTimeOut {
            let grayColor = UIColor(red: (147/255.0), green: (149/255.0), blue: (151/255.0), alpha: 1)
            cell.serviceName.textColor = grayColor
        }
        else {
            let blackColor = UIColor.black
            cell.serviceName.textColor = blackColor
        }
    }
    
    //MARK: callback from BLE manager
    func didDiscoveryService(_ device: BLEDevice) {
        if let services = device.cBPeripheral.services {
            self.gattServiceViewModel.removeAllCellViewModel()
            for index in 0 ..< services.count {
                let cellVM = GattServiceCellViewModel(service: services[index])
                cellVM.AssignCellIndex(index)
                self.gattServiceViewModel.listOfGattServiceViewCell.append(cellVM)
            }
        }
        _ = gattServiceViewModel.checkDFUAvailable()
        gattServicesTableView.reloadData()
    }
    
    //MARK: disconnectAtCharacteristicView
    func deviceDisconnectAtCharacteristicView(_ device: BLEDevice) {
        hasDeviceConnectionStatusChanged(isConnected: false, updatedDevice: device, error: nil)
        setDelegate()
    }
    
    func hasDeviceConnectionStatusChanged(isConnected: Bool, updatedDevice: BLEDevice, error: NSError?) {
        if isConnected {
            gattServiceViewModel.logManager.addLog("Status changed: " + gattServiceViewModel.CONNECTION_STATUS_CONNECTED + " to \(updatedDevice.deviceName)", logType: .info, object: updatedDevice.deviceName, session: self.gattServiceViewModel.session)
            showConnected()
        }
        else {
            gattServiceViewModel.logManager.addLog("Status changed: " + gattServiceViewModel.CONNECTION_STATUS_DISCONNECTED + " from \(updatedDevice.deviceName)", logType: .info, object: updatedDevice.deviceName, session: self.gattServiceViewModel.session)
            showDisconnected()
        }
        controlCellBackgroundWhenConnectionStatusChanged(isConnected)
//        controlTabBarWhenConnectionStatusChanged(isConnected)
        self.gattServiceViewModel.updateSelectedDevice(updatedDevice)
        indicatorControl(shouldStart: false)
    }
    
    //MARK: To characteristic view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCharacteristics" {
            shouldDisconnectOnDisappear = false
            guard let destinationViewController = segue.destination as? GattCharacteristicViewController else { return }
            if let index = (gattServicesTableView.indexPathForSelectedRow as NSIndexPath?)?.row {
                let cellVM = self.gattServiceViewModel.listOfGattServiceViewCell[index]
                destinationViewController.characteristicViewModel.selectedService = cellVM.cbService
                destinationViewController.characteristicViewModel.listOfGattCharacteristicViewCell = GattCharacteristicViewController.PrepareForGattCharacteristicViewModel(cellVM.cbService)
                destinationViewController.characteristicViewModel.setSelectedDevice(gattServiceViewModel.selectedDevice, session: gattServiceViewModel.session)
            }
            destinationViewController.valuesFromGattCharacteristicViewControllerDelegate = self
        }
    }
}
