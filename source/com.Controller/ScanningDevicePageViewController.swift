//
//  ViewController.swift
//  FIrstAppleProject
//
//  Created by Jiajun Qiu on 18/06/15.
//  Copyright © 2015 Jiajun Qiu. All rights reserved.
//

import UIKit
import Foundation
import ExternalAccessory
import SWRevealViewController

extension ScanningDevicePageViewController: ScanButtonSuspendedDelegate {
    func didScanButtonSuspended() {
        changeScanState()
    }
}

extension ScanningDevicePageViewController: BLEDeviceManagerBleHardwareStatusChangedDelegate {
    func hasBleHardwareStatusChanged(_ isAvailable: Bool) {
        let state = self.scanningDevicePageViewModel.BleHardwareStatusChanged(isAvailable)
        if !isAvailable {
            scanPeripheralBarButtom.title = state.description()
            scanPeripheralBarButtom.isEnabled = false
        } else {
            scanPeripheralBarButtom.title = state.description()
            scanPeripheralBarButtom.isEnabled = true
        }
    }
}

extension ScanningDevicePageViewController: ChangeDataViewPopoverDelegate {
    func userChosenManufacturerDataFormatReady(_ userChoice: AdvertisementDataForm, deviceID: String, atRow: Int) {
        if let item = self.userChoices[deviceID] {
            item.setUserChoiceValue(userChoice)
        } else {
            let choice = UserChoiceOnDevice()
            choice.setUserChoiceValue(userChoice)
            userChoices[deviceID] = UserChoiceOnDevice()
        }
        let result = scanningDevicePageViewModel.deviceTableCellViewModelList.index { (device) -> Bool in
            return device.deviceID == deviceID
        }
        if let cell = getVisibleCellView(deviceID), let cellViewModelIndex = result {
            adjustUserChosenCellView(cell, cellViewModel: self.scanningDevicePageViewModel.deviceTableCellViewModelList[cellViewModelIndex])
        }
    }
}

extension ScanningDevicePageViewController {
    //MARK Pop up windows
    @objc func userChoicePopup(_ action:UITapGestureRecognizer) {
        guard let changeDataViewPopoverViewController = self.advDataViewPopoverViewController else { return }
        if let sender = action.view as? UILabel , sender.text == DeviceTableViewCell.ManufacturerDataButtonRestorationKey {
            let cellViewModel = scanningDevicePageViewModel.deviceTableCellViewModelList[sender.tag]
            if let format = userChoices[cellViewModel.deviceID]
            {
                changeDataViewPopoverViewController.currentFormat = format.chosenFormatManufacturerData
            }
            changeDataViewPopoverViewController.deviceID = cellViewModel.deviceID
            changeDataViewPopoverViewController.atRow = sender.tag
            changeDataViewPopoverViewController.chosenLabel = sender
            changeDataViewPopoverViewController.preferredContentSize = changeDataViewPopoverViewController.sizeForManufacturerDatView
        } else if let sender = action.view as? UILabel , sender.text == DeviceTableViewCell.ServiceDataButtonRestorationKey {
            let cellViewModel = scanningDevicePageViewModel.deviceTableCellViewModelList[sender.tag]
            if let format = userChoices[cellViewModel.deviceID]
            {
                changeDataViewPopoverViewController.currentFormat = format.chosenFormatServiceData
            }
            changeDataViewPopoverViewController.deviceID = cellViewModel.deviceID
            changeDataViewPopoverViewController.atRow = sender.tag
            changeDataViewPopoverViewController.chosenLabel = sender
            changeDataViewPopoverViewController.preferredContentSize = changeDataViewPopoverViewController.sizeForServiceDatView
        }
        changeDataViewPopoverViewController.modalPresentationStyle = .popover
        let popoverWriteValueCharacteristic = changeDataViewPopoverViewController.popoverPresentationController
        popoverWriteValueCharacteristic?.permittedArrowDirections = UIPopoverArrowDirection()
        popoverWriteValueCharacteristic?.delegate = self
        popoverWriteValueCharacteristic?.sourceView = self.view
        popoverWriteValueCharacteristic?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
        self.present(changeDataViewPopoverViewController, animated: true, completion: nil)
    }
}

extension ScanningDevicePageViewController: SWRevealViewControllerDelegate {
    //MARK: UIColor Sliding
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if position == .right {
            self.isViewOnSideBarMode = (true, CGFloat(0.00))
        } else if position == .left {
            self.isViewOnSideBarMode = (false, CGFloat(1.00))
        }
        controlIconColorWhenDoPanGuesture()
    }
    
    fileprivate func controlIconColorWhenDoPanGuesture() {
        for itemCell in self.deviceTableView.visibleCells {
            let cellView = itemCell as! DeviceTableViewCell
            let index = cellView.FavouriteButton.tag
            let cellVM = self.scanningDevicePageViewModel.deviceTableCellViewModelList[index]
            colorSetUpForIcon(cellView, cellViewModel: cellVM)
        }
    }
    
    fileprivate func colorSetUpForIcon(_ cell: DeviceTableViewCell, cellViewModel: ScanningDevicePageCellViewModel) {
        if isViewOnSideBarMode.0 {
            setUpIconBackground(cell, displayColor: cellViewModel.displayColor, alphaMiddleLayer: self.isViewOnSideBarMode.1)
        } else
        {
            setUpIconBackground(cell, displayColor: nil, alphaMiddleLayer: self.isViewOnSideBarMode.1)
        }
    }
    
    func revealController(_ revealController: SWRevealViewController!, panGestureMovedToLocation location: CGFloat, progress: CGFloat) {
        sideBarColorMixer(progress)
        controlIconColorWhenDoPanGuesture()
    }
    
    fileprivate func sideBarColorMixer(_ progress: CGFloat) {
        var progFloat = Float(progress)
        let prog = progFloat.roundToPlaces(2)
        if prog > 0 && prog < 0.50 {
            // middle layer dont change
            self.isViewOnSideBarMode = (false, CGFloat(1.00))
        } else if prog >= 0.50 && prog <= 1 {
            // the alpha changing of middle layer should be two times faster that the pan guesture process
            self.isViewOnSideBarMode = (true, CGFloat(2*(1-prog)))
        }
    }
}

extension ScanningDevicePageViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let key = keyPath, key == UserPreferenceScannerTimeOutKey, let changedTo = change else { return }
        guard let _ = changedTo.values.first else { return }
        switch self.scanningDevicePageViewModel.scanButtonStatus {
        case .scanning:
            changeScanState()
            return
        case .offScan:
            return
        case .suspending:
            return
        }
    }
}

class ScanningDevicePageViewController: UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var scanPeripheralBarButtom: UIBarButtonItem!
    @IBOutlet weak var deviceTableView: UITableView!
    @IBOutlet weak var showRSSIButton: UIButton!
    @IBOutlet weak var noDeviceNotificationView: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var FilterLabel: UILabel!
    @IBOutlet weak var FilterDropdownButton: UIButton!
    @IBOutlet weak var FilterClearButton: UIButton!
    @IBOutlet weak var NameFilterTextField: UITextField!
    @IBOutlet weak var RawDataFilterTextField: UITextField!
    @IBOutlet weak var RSSIFilterSlider: UISlider!
    @IBOutlet weak var FilerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var FilterClearButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var iPadFilerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var FilterFieldRSSIIcon: UIImageView!
    @IBOutlet weak var FilterFieldRawDataIcon: UIImageView!
    @IBOutlet weak var FilterFieldSearchIcon: UIImageView!
    @IBOutlet weak var NameFilterTextFieldTitle: UILabel!
    @IBOutlet weak var RSSIFilterSliderTitle: UILabel!
    @IBOutlet weak var RSSIFilterSliderValue: UILabel!
    @IBOutlet weak var FavouriteFilterIcon: UIImageView!
    @IBOutlet weak var FavouriteFilterLabel: UILabel!
    @IBOutlet weak var FavouriteFilterButton: UIButton!
    @IBOutlet weak var NameFilterTextFieldOptionButton: UIButton!
    @IBOutlet weak var RawDataFilterTextFieldOptionButton: UIButton!
    @IBOutlet weak var NameFilterTextFieldClearButton: UIButton!
    @IBOutlet weak var RawDataFilterTextFieldClearButton: UIButton!
    
    fileprivate var isFilterViewInExpandedMode = false
    
    var pushButtonIndex: Int = 1
    var advDataViewPopoverViewController: ChangeDataViewPopoverViewController?
    var refreshControl : UIRefreshControl!
    
    fileprivate var isDeviceUpdatingTimerRunning: Bool = false
    fileprivate var dispatchDeviceUpdatingTimer = Timer()
    
    fileprivate var scannerTimmer = Timer()
    
    var scanningDevicePageViewModel = ScanningDevicePageViewModel()
    
    var deviceTableViewOffsetOnScreen: CGFloat = 0.0
    
    //MARK: Caches on View Side
    fileprivate var userChoices = Dictionary<String, UserChoiceOnDevice>()
    
    var isViewOnSideBarMode : (Bool, iconMiddleLayerAlpha: CGFloat) = (false, 1.00)

    fileprivate class UserChoiceOnDevice {
        var atRow: Int?
        var isExpandedModel: Bool = false
        var chosenFormatManufacturerData = AdvertisementDataForm.notAvailable
        var chosenFormatServiceData = AdvertisementDataForm.notAvailable
        
        func setUserChoiceValue(_ choice: AdvertisementDataForm)
        {
            switch choice
            {
                case .eddystone:
                    chosenFormatServiceData = .eddystone
                    break
                case .serviceDataBytes:
                    chosenFormatServiceData = .serviceDataBytes
                    break
                case .manufacturerDataBytes:
                    chosenFormatManufacturerData = .manufacturerDataBytes
                    break
                case .manufacturerData4_1:
                    chosenFormatManufacturerData = .manufacturerData4_1
                    break
                case .beaconData:
                    chosenFormatManufacturerData = .beaconData
                    break
                default:
                    break
            }
        }
        var isFavourite: Bool = false
        func setDefault() {
            self.isExpandedModel = false
            self.atRow = nil
            self.chosenFormatManufacturerData = AdvertisementDataForm.notAvailable
            self.chosenFormatServiceData = AdvertisementDataForm.notAvailable
        }
    }
    
    @IBAction func showRSSIButtonClicked(_ sender: UIButton) {
        self.pushButtonIndex = sender.tag
        self.revealViewController().revealToggle(sender)
        self.tabBar.tintColor = UIColor.gray
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.pushButtonIndex = item.tag
        self.revealViewController().revealToggle(item)
        self.tabBar.tintColor = UIColor.gray
    }
    //ENDMARK

    //MARK: - View Preparation
    override func viewDidLoad() {
        deviceTableView.dataSource = self
        deviceTableView.delegate = self
        setFilterProperties()
        deviceTableView.rowHeight = UITableViewAutomaticDimension
        deviceTableView.estimatedRowHeight = scanningDevicePageViewModel.maxHeight
        BLEDeviceManager.instance().deviceManagerBleHardwareStatusChangedDelegate = self
        self.scanningDevicePageViewModel.scanningPageStatusDelegate = self
        self.revealViewController().delegate = self
        tabBar.delegate = self
        initializePopoverController()
        addRefreshControl()
        if !isDeviceUpdatingTimerRunning {
            startDeviceUpdating()
        }
        setBarItemTextFont()
        self.navigationController?.delegate = self
        UserDefaults.standard.addObserver(self, forKeyPath: UserPreferenceScannerTimeOutKey, options: .new, context: nil)
    }
    
    func setFilterProperties() {
        self.NameFilterTextField.returnKeyType = .done
        self.RawDataFilterTextField.returnKeyType = .done
        self.NameFilterTextField.delegate = self
        self.RawDataFilterTextField.delegate = self
        self.FilterClearButtonWidth.constant = 0
        self.RawDataFilterTextField.text = DeviceTypeFilterEnum.None.description()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ScanningDevicePageViewController.FilterDropdownButtonClicked(_:)))
        self.FilterLabel.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fireScannerTimmer()
    }
    
    func addBorderLayerOnFilterView() {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: self.filterView.frame.height, width: self.filterView.frame.width, height: 0.5)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        self.filterView.layer.addSublayer(bottomBorder)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        BLEDeviceManager.instance().stopScan()
    }
    
    func initializePopoverController()
    {
        self.advDataViewPopoverViewController = self.storyboard!.instantiateViewController(withIdentifier: "ChangeDataViewPopoverViewController") as? ChangeDataViewPopoverViewController
        if let result = self.advDataViewPopoverViewController
        {
            result.changeDataViewPopoverDelegate = self
        }
    }
    
    func addRefreshControl()
    {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(ScanningDevicePageViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        self.deviceTableView.addSubview(refreshControl)
    }
    
    func addTransparentLayer() {
        // get your window screen size
        let screenRect = UIHelper.screenRect
        //create a new view with the same size
        let coverView = UIView.init(frame: screenRect)
        // change the background color to black and the opacity to 0.6
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        // add this new view to your main view
        self.view.addSubview(coverView)
    }
    
    @objc func refresh(_ sender:AnyObject)
    {
        // Code to refresh table view
        stopDeviceUpdateTimer()
        //delete the listOfDevice Array and the view list
        scanningDevicePageViewModel.freshLocalList()
        //delete all user cached setting except the favourites
        userChoices.forEach { (key, value) in
            if value.isFavourite {
                value.setDefault()
            } else {
                userChoices[key] = nil
            }
        }
        //clear tables
        deviceTableView.reloadData()
        //end refreshing
        self.refreshControl.endRefreshing()
        if self.scanningDevicePageViewModel.scanButtonStatus == .scanning {
            fireDeviceUpdateTimer()
        } else if self.scanningDevicePageViewModel.scanButtonStatus == .offScan {
            changeScanState()
        } else if self.scanningDevicePageViewModel.scanButtonStatus == .suspending {
            //user manually start required
        }
    }
    
    func setBarItemTextFont()
    {
       self.scanPeripheralBarButtom.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)], for: UIControlState())
    }
    //ENDMARK
    
    //MARK: - Scan operation
    @IBAction func ScanPeripheralClicked(_ sender: UIButton) {
        changeScanState()
    }
    
    @objc func changeScanState()
    {
        if self.scanningDevicePageViewModel.scanButtonStatus == .scanning
        {
            BLEDeviceManager.instance().stopScan()
            stopDeviceUpdateTimer()
            scanningDevicePageViewModel.pauseAdvertiserTimeTracker()
            stopScannerTimer()
            //this line have to keep it here
            scanningDevicePageViewModel.changeScanButtonStatusTo(ScanningDevicePageViewModel.ScanState.offScan)
            scanPeripheralBarButtom.title = ScanningDevicePageViewModel.ScanState.offScan.description()
            self.deviceTableView.reloadData()
        }
        else if self.scanningDevicePageViewModel.scanButtonStatus == .offScan
        {
            scanningDevicePageViewModel.changeScanButtonStatusTo(ScanningDevicePageViewModel.ScanState.scanning)
            fireScannerTimmer()
            BLEDeviceManager.instance().discoverDevices()
            startDeviceUpdating()
            scanPeripheralBarButtom.title = ScanningDevicePageViewModel.ScanState.scanning.description()
        } else if self.scanningDevicePageViewModel.scanButtonStatus == .suspending {
            stopDeviceUpdateTimer()
            scanningDevicePageViewModel.pauseAdvertiserTimeTracker()
            stopScannerTimer()
            self.deviceTableView.reloadData()
        }
    }
    
    //MARK: Preparation for next service view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowServices" {
            guard let indexOfSelectedRow = (sender as AnyObject).tag else { return }
            self.scanningDevicePageViewModel.selectedCellVM = self.scanningDevicePageViewModel.deviceTableCellViewModelList[indexOfSelectedRow]
            let gattServiceVC = segue.destination as! GattServiceViewController
            gattServiceVC.gattServiceViewModel.setSelectedDevice(self.scanningDevicePageViewModel.selectedCellVM.bleDevice, session: self.scanningDevicePageViewModel.createSession())
        }
    }

    //MARK: Timmer - updating device table
    func startDeviceUpdating() {
        if !isDeviceUpdatingTimerRunning{
            dispatchDeviceUpdatingTimer = Timer.scheduledTimer(timeInterval: scanningDevicePageViewModel.timeToRenderTheDeviceTableSecond, target: self, selector: #selector(ScanningDevicePageViewController.updateDeviceTableView), userInfo: nil, repeats: true)
            isDeviceUpdatingTimerRunning = true
        }
    }
    
    //MARK: Timmer - scanning controller
    func fireScannerTimmer() {
        guard scanningDevicePageViewModel.isOnScanningState() else {
            return
        }
        scannerTimmer = Timer.scheduledTimer(timeInterval: UserPreference.instance.scannerTimeOut.getTimeInterval(), target: self, selector: #selector(ScanningDevicePageViewController.changeScanState), userInfo: nil, repeats: false)
    }
    
    // it may apply when suspending and stop scanning state
    @objc func updateDeviceTableView() {
        //guard !self.scanningDevicePageViewModel.isTableViewScrolling() else { return }
        self.scanningDevicePageViewModel.BuildDeviceTableCellViewModel()
        manageClientSettingsBuffer()
        self.deviceTableView.reloadData()
    }

    func manageClientSettingsBuffer() {
        for (key, value) in userChoices {
            if let newDevice = self.scanningDevicePageViewModel.deviceTableCellViewModelList.filter({ x in x.deviceID == key }).first {
               if (newDevice.manufacturerData.beaconDataFormatedString == Symbols.NOT_AVAILABLE && newDevice.manufacturerData.manufactureData4_1FormatedString == Symbols.NOT_AVAILABLE) || newDevice.manufacturerData.rawStringFormat == Symbols.NOT_AVAILABLE {
                    userChoices[key]?.chosenFormatManufacturerData = AdvertisementDataForm.notAvailable
               }
               if newDevice.serviceData.eddystoneFormatedString == Symbols.NOT_AVAILABLE || newDevice.serviceData.rawStringFormat == Symbols.NOT_AVAILABLE {
                    userChoices[key]?.chosenFormatServiceData = AdvertisementDataForm.notAvailable
               }
               if value.isFavourite {
                    userChoices[key]?.isFavourite = true
                }
            } else {
                //let it be in the cache
            }
        }
    }
    
    func stopDeviceUpdateTimer(){
        guard isDeviceUpdatingTimerRunning else { return }
        dispatchDeviceUpdatingTimer.invalidate()
        isDeviceUpdatingTimerRunning = false
    }
    
    func stopScannerTimer() {
        guard !scanningDevicePageViewModel.isOnScanningState() else { return }
        self.scannerTimmer.invalidate()
    }
    
    func fireDeviceUpdateTimer() {
        guard !isDeviceUpdatingTimerRunning else { return }
        startDeviceUpdating()
    }
    //ENDMARK
    
    //MARK: preparation for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.scanningDevicePageViewModel.deviceTableCellViewModelList.count;
        if count > 0 {
            self.noDeviceNotificationView.isHidden = true
        }
        else {
            self.noDeviceNotificationView.isHidden = false
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = (indexPath as NSIndexPath).row;
        if self.scanningDevicePageViewModel.deviceTableCellViewModelList.count > 0 {
            let cellView = self.scanningDevicePageViewModel.deviceTableCellViewModelList[row]
            if let userChoice = userChoices[cellView.deviceID] {
                if userChoice.isExpandedModel {
                    return UITableViewAutomaticDimension
                }
                else {
                    return scanningDevicePageViewModel.minHeight
                }
            } else {
                return scanningDevicePageViewModel.minHeight
            }
        }
        else {
            return scanningDevicePageViewModel.minHeight
        }
    }
    
    @IBAction func RowExpandButtonPressed(_ sender: UIButton) {
        let selectedRowIndex = sender.tag
        if self.scanningDevicePageViewModel.deviceTableCellViewModelList.count > 0 {
            let cellViewModel = self.scanningDevicePageViewModel.deviceTableCellViewModelList[selectedRowIndex]
            if let userChoice = userChoices[cellViewModel.deviceID] {
                if userChoice.isExpandedModel {
                    userChoice.isExpandedModel = false
                }
                else {
                    userChoice.isExpandedModel = true
                }
            } else {
                let newUserChoice = UserChoiceOnDevice()
                newUserChoice.isExpandedModel = true
                userChoices[cellViewModel.deviceID] = newUserChoice
            }
            reloadRowAt(selectedRowIndex)
        }
    }
    
    fileprivate func reloadRowAt(_ row: Int){
        let indexPaths: Array<IndexPath> = [getIndexPath(row)]
        deviceTableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DeviceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DeviceTableViewCell", for: indexPath) as! DeviceTableViewCell
        let row = indexPath.row
        var listOfdeviceCellVM = self.scanningDevicePageViewModel.deviceTableCellViewModelList
        if listOfdeviceCellVM.count == 0 {
            return cell
        } else if listOfdeviceCellVM.count > 0 {
            let cellViewModel = listOfdeviceCellVM[row]
            cell.ConnectPeripheralButton.tag = row
            cell.ManufacturerDataLabel.tag = row
            cell.ServiceDataLabel.tag = row
            cell.FavouriteButton.tag = row
            cell.RowExpandButton.tag = row
            cell.deviceName.text = cellViewModel.deviceName
            cell.isConnectable.text = cellViewModel.connectionStatus
            cell.deviceSignalStrengthen.text = cellViewModel.rssi
            cell.intervalValueLabel.text = cellViewModel.interval
            adjustUserChosenCellView(cell, cellViewModel: cellViewModel)
            cell.serviceUUID.text = cellViewModel.getServiceUUID()
            if let format = userChoices[cellViewModel.deviceID] , format.isFavourite == true {
                setIconFavouriteConstrains(cell, shouldHide: false)
            } else {
                setIconFavouriteConstrains(cell, shouldHide: true)
            }
            cell.TxPowerLevel.text = cellViewModel.txPowerLevel
            cell.solicitedServiceUUID.text = cellViewModel.solicitedServiceUUIDString
            cell.CompleteLocalName.text = cellViewModel.completeLocalName
            cell.OverflowServiceUUID.text = cellViewModel.getOverflowUUIDs()
            colorSetUpForIcon(cell, cellViewModel: cellViewModel)
            showHideConnectButton(cell, isConnectable: cellViewModel.isConnectable)
            if cellViewModel.isDeviceOutOfRange || !cellViewModel.isValidatedInterval {
                controlRSSIColor(cell: cell, color: UIColor.lightGray)
            } else {
                controlRSSIColor(cell: cell, color: UIColor.black)
            }
        }
        return cell
    }
    
    fileprivate func controlRSSIColor(cell: DeviceTableViewCell, color: UIColor) {
        cell.deviceSignalStrengthen.textColor = color
        cell.intervalValueLabel.textColor = color
    }
    
    fileprivate func ShouldHideDetailView(_ shouldHideFilter: Bool, cell: DeviceTableViewCell) {
        cell.CompleteLocalName.isHidden = shouldHideFilter
        cell.manufacturerData.isHidden = shouldHideFilter
        cell.TxPowerLevel.isHidden = shouldHideFilter
        cell.solicitedServiceUUID.isHidden = shouldHideFilter
        cell.serviceUUID.isHidden = shouldHideFilter
        cell.serviceData.isHidden = shouldHideFilter
        cell.OverflowServiceUUID.isHidden = shouldHideFilter
        cell.CompleteLocalNameLabel.isHidden = shouldHideFilter
        cell.ManufacturerDataLabel.isHidden = shouldHideFilter
        cell.TxPowerLevel.isHidden = shouldHideFilter
        cell.SolicitedServiceUUIDLabel.isHidden = shouldHideFilter
        cell.ServiceUUIDLabel.isHidden = shouldHideFilter
        cell.ServiceDataLabel.isHidden = shouldHideFilter
        cell.OverflowServiceUUIDLabel.isHidden = shouldHideFilter
    }
    
    fileprivate func adjustUserChosenCellView(_ cell: DeviceTableViewCell, cellViewModel: ScanningDevicePageCellViewModel) {
        deregisterManufactureDataLabelPresentation(cell, cellViewModel: cellViewModel)
        deregisterServiceDataLabelPresentation(cell, cellViewModel: cellViewModel)
        guard let format = userChoices[cellViewModel.deviceID] else {
            cell.manufacturerData.text = cellViewModel.manufacturerData.rawStringFormat
            cell.serviceData.text = cellViewModel.serviceData.rawStringFormat
            return
        }
        if format.chosenFormatManufacturerData == AdvertisementDataForm.beaconData {
            setupManufactureDataLabelPresentation(cell, cellViewModel: cellViewModel)
            cell.manufacturerData.text = cellViewModel.manufacturerData.beaconName
        } else if format.chosenFormatManufacturerData == AdvertisementDataForm.manufacturerDataBytes {
            setupManufactureDataLabelPresentation(cell, cellViewModel: cellViewModel)
            cell.manufacturerData.text = cellViewModel.manufacturerData.rawStringFormat
        } else if format.chosenFormatManufacturerData == AdvertisementDataForm.manufacturerData4_1 {
            setupManufactureDataLabelPresentation(cell, cellViewModel: cellViewModel)
            cell.manufacturerData.text = cellViewModel.manufacturerData.manufactureData4_1FormatedString
        } else if cellViewModel.manufacturerData.beaconDataFormatedString != Symbols.NOT_AVAILABLE || cellViewModel.manufacturerData.manufactureData4_1FormatedString != Symbols.NOT_AVAILABLE {
            setupManufactureDataLabelPresentation(cell, cellViewModel: cellViewModel)
            cell.manufacturerData.text = cellViewModel.manufacturerData.rawStringFormat
        } else {
            cell.manufacturerData.text = cellViewModel.manufacturerData.rawStringFormat
        }
        if format.chosenFormatServiceData == AdvertisementDataForm.eddystone {
            setupServiceDataLabelPresentation(cell, cellViewModel: cellViewModel)
            cell.serviceData.text = cellViewModel.serviceData.eddystoneFormatedString
        } else if format.chosenFormatServiceData == AdvertisementDataForm.serviceDataBytes {
            setupServiceDataLabelPresentation(cell, cellViewModel: cellViewModel)
            cell.serviceData.text = cellViewModel.serviceData.rawStringFormat
        } else if cellViewModel.serviceData.eddystoneFormatedString != Symbols.NOT_AVAILABLE {
            setupServiceDataLabelPresentation(cell, cellViewModel: cellViewModel)
            cell.serviceData.text = cellViewModel.serviceData.rawStringFormat
        } else {
            cell.serviceData.text = cellViewModel.serviceData.rawStringFormat
        }
    }
    
    fileprivate func setUpIconBackground(_ cell: DeviceTableViewCell, displayColor: UIColor?, alphaMiddleLayer: CGFloat) {
        cell.IconBackground.backgroundColor = displayColor
        cell.IconBackground.layer.cornerRadius = 20
        cell.IconMiddleBackground.layer.cornerRadius = 20
        cell.IconMiddleBackground.alpha = alphaMiddleLayer
        cell.icon.layer.cornerRadius = 12
    }
    
    fileprivate func setupManufactureDataLabelPresentation(_ cell: DeviceTableViewCell, cellViewModel: ScanningDevicePageCellViewModel) {
        cell.ManufacturerDataLabel.textColor = UIColor.nordicBlue()
        cell.ManufacturerDataLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ScanningDevicePageViewController.userChoicePopup(_:)))
        cell.ManufacturerDataLabel.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func deregisterManufactureDataLabelPresentation(_ cell: DeviceTableViewCell, cellViewModel: ScanningDevicePageCellViewModel) {
        cell.ManufacturerDataLabel.textColor = UIColor.darkGray
        cell.ManufacturerDataLabel.isUserInteractionEnabled = false
    }
    
    fileprivate func setupServiceDataLabelPresentation(_ cell: DeviceTableViewCell, cellViewModel: ScanningDevicePageCellViewModel) {
        cell.ServiceDataLabel.textColor = UIColor.nordicBlue()
        cell.ServiceDataLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ScanningDevicePageViewController.userChoicePopup(_:)))
        cell.ServiceDataLabel.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func deregisterServiceDataLabelPresentation(_ cell: DeviceTableViewCell, cellViewModel: ScanningDevicePageCellViewModel) {
        cell.ServiceDataLabel.textColor = UIColor.darkGray
        cell.ServiceDataLabel.isUserInteractionEnabled = false
    }
    //ENDMARK
    
    fileprivate func showHideConnectButton(_ cell: DeviceTableViewCell, isConnectable: Bool?) {
        if let result = isConnectable , result == true {
            cell.isConnectable.text = self.scanningDevicePageViewModel.CONNECTABLE
            cell.ConnectPeripheralButton.isHidden = false
            cell.ConnectPeripheralButton.layer.cornerRadius = 0.05*cell.ConnectPeripheralButton.bounds.size.width
            cell.ConnectPeripheralButton.clipsToBounds = true
        }
        else if let result = isConnectable , result == false {
            cell.isConnectable.text = self.scanningDevicePageViewModel.NON_CONNECTABLE
            cell.ConnectPeripheralButton.isHidden = true
        }
    }
    
    //MARK: TableView monitor
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {} else{}
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scanningDevicePageViewModel.setDraggingStatus(isOnDragging: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.scanningDevicePageViewModel.setDraggingStatus(isOnDragging: false)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.scanningDevicePageViewModel.setDeceleratingStatus(isOnDecelerating: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scanningDevicePageViewModel.setDeceleratingStatus(isOnDecelerating: false)
    }
    
    fileprivate func getVisibleCellView(_ deviceID: String) -> DeviceTableViewCell! {
        var targetCellView: DeviceTableViewCell!
        for item in self.deviceTableView.visibleCells {
            let itemCell = item as! DeviceTableViewCell
            if itemCell.deviceID == deviceID {
                targetCellView = itemCell
            }
        }
        return targetCellView
    }
    
    func getIndexPath(_ cellIndex: Int) -> IndexPath {
        let indexPath = IndexPath(row: cellIndex, section: 0)
        return indexPath
    }
    //ENDMARK
    
    //MARK: Filter function
    @IBAction func FilterDropdownButtonClicked(_ sender: UITapGestureRecognizer) {
        resetFilterViewHeight()
    }
    
    fileprivate func RotateDropDownFilterButtonIcon(_ rotation: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn , animations: {
        self.FilterDropdownButton.imageView!.transform = CGAffineTransform(rotationAngle: rotation)}, completion: nil)
    }

    fileprivate func resetFilterViewHeight() {
        if isFilterViewInExpandedMode {
            if self.NameFilterTextField.isFirstResponder {
                self.NameFilterTextField.resignFirstResponder()
            } else if self.RawDataFilterTextField.isFirstResponder {
                self.RawDataFilterTextField.resignFirstResponder()
            }
            if AppInfo.deviceModel == .phone {
                FilerViewHeight.constant = self.scanningDevicePageViewModel.filterViewLimited
            } else if AppInfo.deviceModel == .pad
            {
                iPadFilerViewHeight.constant = self.scanningDevicePageViewModel.filterViewLimited
            }
            RotateDropDownFilterButtonIcon(180 * CGFloat(Double.pi) * 180)
            HideFilters(true)
        } else
        {
            self.NameFilterTextField.becomeFirstResponder()
            if AppInfo.deviceModel == .phone {
                FilerViewHeight.constant = self.scanningDevicePageViewModel.filterViewExpaned
            } else if AppInfo.deviceModel == .pad
            {
                iPadFilerViewHeight.constant = self.scanningDevicePageViewModel.filterViewExpaned
            }
            HideFilters(false)
            RotateDropDownFilterButtonIcon(CGFloat(Double.pi))
        }
        isFilterViewInExpandedMode = !isFilterViewInExpandedMode
    }
    
    fileprivate func HideFilters(_ HideFilters: Bool) {
        FilterFieldRSSIIcon.isHidden = HideFilters
        FilterFieldSearchIcon.isHidden = HideFilters
        FilterFieldRawDataIcon.isHidden = HideFilters
        NameFilterTextField.isHidden = HideFilters
        RawDataFilterTextField.isHidden = HideFilters
        RSSIFilterSlider.isHidden = HideFilters
        NameFilterTextFieldTitle.isHidden = HideFilters
        RSSIFilterSliderTitle.isHidden = HideFilters
        RSSIFilterSliderValue.isHidden = HideFilters
        FavouriteFilterIcon.isHidden = HideFilters
        FavouriteFilterLabel.isHidden = HideFilters
        FavouriteFilterButton.isHidden = HideFilters
        NameFilterTextFieldOptionButton.isHidden = HideFilters
        RawDataFilterTextFieldOptionButton.isHidden = HideFilters
        NameFilterTextFieldClearButton.isHidden = HideFilters
        RawDataFilterTextFieldClearButton.isHidden = HideFilters
    }
    
    @IBAction func rssiSliderValueChanged(_ sender: UISlider) {
        let rssiFilter = Int(sender.value.roundToPlaces(0))
        self.RSSIFilterSliderValue.text = String(rssiFilter) + " " + Symbols.dBm
    }
    
    fileprivate func getRssiValue() -> Int {
        let rssiFilter = Int(self.RSSIFilterSlider.value.roundToPlaces(0))
        return rssiFilter
    }
    
    @IBAction func showFavouriteButtonPressed(_ sender: UIButton) {
        let showingFav = self.FavouriteFilterButton.tag != 0 ? true : false
        if  !showingFav {
            let image = UIImage(named: "ic_radio_button_checked_blue") as UIImage?
            self.FavouriteFilterButton.setImage(image, for: UIControlState())
            self.FavouriteFilterButton.tag = 1
            
        } else {
            uncheckFavouriteButton ()
        }
    }
    
    fileprivate func uncheckFavouriteButton () {
        let image = UIImage(named: "ic_radio_button_unchecked_blue") as UIImage?
        self.FavouriteFilterButton.setImage(image, for: UIControlState())
        self.FavouriteFilterButton.tag = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nameFilter = (self.NameFilterTextField.text)?.trimmingCharacters(in: CharacterSet.whitespaces)
        let deviceTypeFilter = self.RawDataFilterTextField.text
        let rssiFilter = getRssiValue()
        self.scanningDevicePageViewModel.setNewDeviceFilter()
        self.scanningDevicePageViewModel.filterSettings.showOnlyFavourite = self.FavouriteFilterButton.tag != 0 ? true : false
        self.scanningDevicePageViewModel.filterSettings.nameFilter = nameFilter!
        self.scanningDevicePageViewModel.filterSettings.deviceTypeFilter = DeviceTypeFilterEnum.getDeviceType(deviceTypeFilter!)
        self.scanningDevicePageViewModel.filterSettings.rssi = Float(rssiFilter)
        if self.scanningDevicePageViewModel.filterSettings.showOnlyFavourite {
            for (key, value) in self.userChoices {
                if value.isFavourite {
                    self.scanningDevicePageViewModel.filterSettings.favourite.append(key)
                }
            }
        }
        showChosenFilter()
        if scanningDevicePageViewModel.shouldFilterStaticPage() { updateDeviceTableView() }
        else {
            // will be handeled by the scanner
        }
        resetFilterViewHeight()
        return true
    }
    
    @IBAction func NameFilterTextFieldClearButtonPressed(_ sender: UIButton) {
        self.scanningDevicePageViewModel.resetDeviceNameFilter()
        NameFilterTextField.text = self.scanningDevicePageViewModel.filterSettings.nameFilter
    }
    
    @IBAction func RawDataFilterTextFieldClearButtonPressed(_ sender: UIButton) {
        RawDataFilterTextField.text = DeviceTypeFilterEnum.None.description()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // not allow editing on device type filter
        if textField.tag == 2 { return false }
        return true
    }
    
    func showChosenFilter() {
        guard self.scanningDevicePageViewModel.isFilterValidated() else {
            FilterLabel.text = self.scanningDevicePageViewModel.filterSettings.NO_FILTER
            return
        }
        FilterLabel.text = self.scanningDevicePageViewModel.filterSettings.description()
        self.FilterClearButtonWidth.constant = 44
    }
    
    @IBAction func FilterClearButtonPressed(_ sender: UIButton) {
        FilterLabel.text = self.scanningDevicePageViewModel.filterSettings.NO_FILTER
        self.FilterClearButtonWidth.constant = 0
        self.scanningDevicePageViewModel.turnOffDeviceFilters()
        let defaultValues = self.scanningDevicePageViewModel.filterSettings
        NameFilterTextField.text = defaultValues.nameFilter
        RawDataFilterTextField.text = defaultValues.deviceTypeFilter.description()
        RSSIFilterSlider.value = defaultValues.rssi
        uncheckFavouriteButton()
        RSSIFilterSliderValue.text = defaultValues.rssiString()
        if scanningDevicePageViewModel.shouldFilterStaticPage() {
            updateDeviceTableView()
        }
    }
    
    @IBAction func FavouriteButtonPressed(_ sender: UIButton) {
        let indexOfSelectedRow = sender.tag
        let cellView = findCellInView(indexOfSelectedRow)

        let cellViewModel = self.scanningDevicePageViewModel.deviceTableCellViewModelList[indexOfSelectedRow]
        if let item = self.userChoices[cellViewModel.deviceID] {
            if item.isFavourite {
                setIconFavouriteConstrains(cellView!, shouldHide: true)
                //In this case the view is in filter mode and user want to remove any of the favourited device, we need update filter
                self.scanningDevicePageViewModel.removeFromFavouriteList(cellViewModel.deviceID)
            } else {
                setIconFavouriteConstrains(cellView!, shouldHide: false)
            }
            item.isFavourite = !item.isFavourite
        } else {
            let choice = UserChoiceOnDevice()
            choice.atRow = indexOfSelectedRow
            choice.isFavourite = true
            setIconFavouriteConstrains(cellView!, shouldHide: false)
            self.userChoices[cellViewModel.deviceID] = choice
        }
        if scanningDevicePageViewModel.shouldFilterStaticPage() {
            updateDeviceTableView()
        }
    }
    
    fileprivate func findCellInView(_ indexOfSelectedRow: Int) -> DeviceTableViewCell! {
        var cellView: DeviceTableViewCell!
        for item in self.deviceTableView.visibleCells {
            cellView = item as! DeviceTableViewCell
            if cellView.FavouriteButton.tag == indexOfSelectedRow {
                return cellView
            }
        }
        return cellView
    }
    
    fileprivate func setIconFavouriteConstrains(_ cellView: DeviceTableViewCell, shouldHide: Bool) {
        if shouldHide {
            if AppInfo.deviceModel == .phone {
                cellView.IconFavouriteTopIconBackgroundBottomConstrain.constant = -15
                cellView.IconFavouriteHeight.constant = 0
            } else if AppInfo.deviceModel == .pad
            {
                cellView.iPadIconFavouriteTopIconBackgroundBottomConstrain.constant = -15
                cellView.iPadIconFavouriteHeight.constant = 0
            }
        } else {
            if AppInfo.deviceModel == .phone {
                cellView.IconFavouriteTopIconBackgroundBottomConstrain.constant = -3
                cellView.IconFavouriteHeight.constant = 15
            } else if AppInfo.deviceModel == .pad {
                cellView.iPadIconFavouriteTopIconBackgroundBottomConstrain.constant = -3
                cellView.iPadIconFavouriteHeight.constant = 15
            }
        }
    }
    
    @IBAction func NameFilterOptionButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Name filter", message: "search text contains in a name", preferredStyle: .actionSheet)
        let defaultAction1 = UIAlertAction(title: "No name", style: .default, handler: {
            action in
                self.NameFilterTextField.text = Symbols.NOT_AVAILABLE
        })
        let defaultAction2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(defaultAction1)
        alertController.addAction(defaultAction2)
        if AppInfo.deviceModel == .pad {
            alertController.popoverPresentationController?.sourceView = sender
        }
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func DeviceTypeFilterOptionButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Device type filter", message: "search a device has such service", preferredStyle: .actionSheet)
        
        let defaultAction1 = UIAlertAction(title: DeviceTypeFilterEnum.nRFBeacon.description(), style: .default, handler: {
            action in
            self.RawDataFilterTextField.text = String(DeviceTypeFilterEnum.nRFBeacon.description())
        })
        let defaultAction2 = UIAlertAction(title: DeviceTypeFilterEnum.Eddystone.description(), style: .default, handler: {
            action in
            self.RawDataFilterTextField.text = String(DeviceTypeFilterEnum.Eddystone.description())
        })
        let defaultAction3 = UIAlertAction(title: DeviceTypeFilterEnum.PhysicalWeb.description(), style: .default, handler: {
            action in
            self.RawDataFilterTextField.text = String(DeviceTypeFilterEnum.PhysicalWeb.description())
        })
        let defaultAction4 = UIAlertAction(title: DeviceTypeFilterEnum.SecureDFU.description(), style: .default, handler: {
            action in
            self.RawDataFilterTextField.text = String(DeviceTypeFilterEnum.SecureDFU.description())
        })
        let defaultAction5 = UIAlertAction(title: DeviceTypeFilterEnum.LegacyDFU.description(), style: .default, handler: {
            action in
            self.RawDataFilterTextField.text = String(DeviceTypeFilterEnum.LegacyDFU.description())
        })
        let defaultAction6 = UIAlertAction(title: DeviceTypeFilterEnum.Thingy.description(), style: .default, handler: {
            action in
            self.RawDataFilterTextField.text = String(DeviceTypeFilterEnum.Thingy.description())
        })
        let defaultAction7 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(defaultAction1)
        alertController.addAction(defaultAction2)
        alertController.addAction(defaultAction3)
        alertController.addAction(defaultAction4)
        alertController.addAction(defaultAction5)
        alertController.addAction(defaultAction6)
        alertController.addAction(defaultAction7)
        if AppInfo.deviceModel == .pad {
            alertController.popoverPresentationController?.sourceView = sender
        }
        present(alertController, animated: true, completion: nil)
    }
}

