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

//MARK: - Pop up windows
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
    func userChosenDataFormatReady(_ userChoice: AdvertisementDataForm, deviceID: String, indexPath: IndexPath) {
        guard let cache = self.userChoices[deviceID] else { return }
        cache.setUserChoiceValue(userChoice)
        cache.expandedHeight = nil
        reloadRowAt(indexPath.row)
    }
}

extension ScanningDevicePageViewController {
    @objc func userChoicePopup(_ action:UITapGestureRecognizer) {
        guard let sender = action.view as? UILabel, let changeDataViewPopoverViewController = self.advDataViewPopoverViewController else { return }
        let cellViewModel = scanningDevicePageViewModel.deviceTableCellViewModelList[sender.tag]
        let indexPath = getIndexPath(sender.tag)
        guard let format = userChoices[cellViewModel.deviceID] else { return }
        if sender.text == DeviceTableViewCell.ManufacturerDataButtonRestorationKey {
            changeDataViewPopoverViewController.currentFormat = format.chosenFormatManufacturerData
            changeDataViewPopoverViewController.preferredContentSize = changeDataViewPopoverViewController.sizeForManufacturerDatView
        } else if sender.text == DeviceTableViewCell.ServiceDataButtonRestorationKey {
            changeDataViewPopoverViewController.currentFormat = format.chosenFormatServiceData
            changeDataViewPopoverViewController.preferredContentSize = changeDataViewPopoverViewController.sizeForServiceDatView
        }
        changeDataViewPopoverViewController.deviceID = cellViewModel.deviceID
        changeDataViewPopoverViewController.atRow = indexPath
        changeDataViewPopoverViewController.chosenLabel = sender
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
        DispatchQueue.main.async {
            if self.isViewOnSideBarMode.0 {
                self.setUpIconBackground(cell, displayColor: cellViewModel.displayColor, alphaMiddleLayer: self.isViewOnSideBarMode.1)
            } else {
                self.setUpIconBackground(cell, displayColor: nil, alphaMiddleLayer: self.isViewOnSideBarMode.1)
            }
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
        guard let key = keyPath, key == UserPreferenceScannerTimeOutKey, let changedTo = change, let _ = changedTo.values.first else { return }
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
        var index: IndexPath
        var isExpandedModel: Bool = false
        var expandedHeight: CGFloat!
        var isFavourite: Bool = false
        var chosenFormatManufacturerData = AdvertisementDataForm.manufacturerData4_1
        var chosenFormatServiceData = AdvertisementDataForm.eddystone
        
        init(_ index: IndexPath) {
            self.index = index
        }
        
        func setUserChoiceValue(_ choice: AdvertisementDataForm) {
            switch choice {
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
        
        func setDefault() {
            self.isExpandedModel = false
            self.chosenFormatManufacturerData = AdvertisementDataForm.manufacturerData4_1
            self.chosenFormatServiceData = AdvertisementDataForm.beaconData
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
    }
    
    func initializePopoverController()
    {
        self.advDataViewPopoverViewController = self.storyboard!.instantiateViewController(withIdentifier: "ChangeDataViewPopoverViewController") as? ChangeDataViewPopoverViewController
        if let result = self.advDataViewPopoverViewController {
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
    
    @objc func refresh(_ sender:AnyObject) {
        if self.scanningDevicePageViewModel.scanButtonStatus == .scanning {
            // Code to refresh table view
            stopDeviceUpdateTimer()
        }
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
        guard self.scanningDevicePageViewModel.didDataSourceChanged else { return }
        deviceTableView.reloadData()
        self.scanningDevicePageViewModel.didDataSourceChanged = false
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
    
    func setBarItemTextFont() {
       self.scanPeripheralBarButtom.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)], for: UIControlState())
    }
    //ENDMARK
    
    //MARK: - Scan operation
    @IBAction func ScanPeripheralClicked(_ sender: UIButton) {
        changeScanState()
    }
    
    @objc func changeScanState() {
        if self.scanningDevicePageViewModel.scanButtonStatus == .scanning {
            BLEDeviceManager.instance().stopScan()
            stopDeviceUpdateTimer()
            scanningDevicePageViewModel.pauseAdvertiserTimeTracker()
            stopScannerTimer()
            //this line have to keep it here
            scanningDevicePageViewModel.changeScanButtonStatusTo(ScanningDevicePageViewModel.ScanState.offScan)
            scanPeripheralBarButtom.title = ScanningDevicePageViewModel.ScanState.offScan.description()
            self.deviceTableView.reloadData()
        }
        else if self.scanningDevicePageViewModel.scanButtonStatus == .offScan {
            scanningDevicePageViewModel.changeScanButtonStatusTo(ScanningDevicePageViewModel.ScanState.scanning)
            fireScannerTimmer()
            BLEDeviceManager.instance().discoverDevices()
            startDeviceUpdating()
            scanPeripheralBarButtom.title = ScanningDevicePageViewModel.ScanState.scanning.description()
        } else if self.scanningDevicePageViewModel.scanButtonStatus == .suspending {
            stopDeviceUpdateTimer()
            scanningDevicePageViewModel.pauseAdvertiserTimeTracker()
            stopScannerTimer()
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
        guard scanningDevicePageViewModel.isOnScanningState() else { return }
        scannerTimmer = Timer.scheduledTimer(timeInterval: UserPreference.instance.scannerTimeOut.getTimeInterval(), target: self, selector: #selector(ScanningDevicePageViewController.changeScanState), userInfo: nil, repeats: false)
    }
    
    // it may apply when suspending and stop scanning state
    @objc func updateDeviceTableView() {
        self.scanningDevicePageViewModel.BuildDeviceTableCellViewModel()
        var newRowsIndexPaths: [IndexPath] = []
        for index in 0..<self.scanningDevicePageViewModel.deviceTableCellViewModelList.count {
            let cellViewModel = self.scanningDevicePageViewModel.deviceTableCellViewModelList[index]
            guard !cellViewModel.isPushedToView else {
                //if cell is not in the view, not update
                guard let cell = getVisibleCellView(cellViewModel.deviceID) else { continue }
                self.updateSignalInterval(cell, cellViewModel: cellViewModel)
                continue }
            newRowsIndexPaths.append(self.getIndexPath(index))
        }
        
        
        DispatchQueue.main.async {
            guard newRowsIndexPaths.count > 0, self.deviceTableView.numberOfRows(inSection: 0) + newRowsIndexPaths.count == self.scanningDevicePageViewModel.deviceTableCellViewModelList.count else {
                return
            }
            self.deviceTableView.insertRows(at: newRowsIndexPaths, with: .top)
            self.deviceTableView.beginUpdates()
            self.deviceTableView.endUpdates()
        }
        for index in newRowsIndexPaths {
            self.scanningDevicePageViewModel.deviceTableCellViewModelList[index.row].isPushedToView = true
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
        let count = self.scanningDevicePageViewModel.deviceTableCellViewModelList.count
        if count > 0 {
            self.noDeviceNotificationView.isHidden = true
        } else {
            self.noDeviceNotificationView.isHidden = false
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellView = self.scanningDevicePageViewModel.deviceTableCellViewModelList[indexPath.row]
        guard cellView.isSatisfiedForFilter else { return self.scanningDevicePageViewModel.miniHeight }
        let cache = userChoices[cellView.deviceID]
        if let userChoice = cache, userChoice.isExpandedModel, let height = userChoice.expandedHeight {
            return height
        } else if let userChoice = cache, userChoice.isExpandedModel, userChoice.expandedHeight == nil {
            return UITableViewAutomaticDimension
        } else {
            return scanningDevicePageViewModel.defaulHeight
        }
    }
    
    @IBAction func RowExpandButtonPressed(_ sender: UIButton) {
        guard let index = getIndexPath(expandButton: sender) else { return }
        let cellViewModel = self.scanningDevicePageViewModel.deviceTableCellViewModelList[index.row]
        if let userChoice = userChoices[cellViewModel.deviceID] {
            userChoice.isExpandedModel = !userChoice.isExpandedModel
        } else {
            let newUserChoice = UserChoiceOnDevice(index)
            newUserChoice.isExpandedModel = true
            if let data = cellViewModel.serviceData, !data.hasMultiFormation { newUserChoice.chosenFormatServiceData = .serviceDataBytes }
            if let data = cellViewModel.manufacturerData, !data.hasMultiFormation { newUserChoice.chosenFormatManufacturerData = .manufacturerDataBytes }
            userChoices[cellViewModel.deviceID] = newUserChoice
        }
        self.reloadRowAt(index.row)
    }
    
    private func getIndexPath(expandButton sender: UIButton) -> IndexPath? {
        guard let cellView = sender.superview?.superview?.superview?.superview as? DeviceTableViewCell else { return nil }
        return deviceTableView.indexPath(for: cellView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deviceTableView.deselectRow(at: indexPath, animated: true)
    }
    
    fileprivate func reloadRowAt(_ row: Int) {
        let indexPaths: [IndexPath] = [getIndexPath(row)]
        DispatchQueue.main.async {
            self.deviceTableView.reloadRows(at: indexPaths, with: .automatic)
            self.deviceTableView.beginUpdates()
            self.deviceTableView.endUpdates()
            let cellViewModel = self.scanningDevicePageViewModel.deviceTableCellViewModelList[row]
            guard let cache = self.userChoices[cellViewModel.deviceID] else { return }
            guard let cellView = self.getVisibleCellView(cellViewModel.deviceID) else { cache.expandedHeight = self.scanningDevicePageViewModel.miniHeight; return }
            guard cellView.frame.height != self.scanningDevicePageViewModel.defaulHeight else { return }
            cache.expandedHeight = cellView.frame.height
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DeviceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DeviceTableViewCell", for: indexPath) as! DeviceTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellView = cell as! DeviceTableViewCell
        let cellViewModel = self.scanningDevicePageViewModel.deviceTableCellViewModelList[indexPath.row]
        if let usrCache = self.userChoices[cellViewModel.deviceID], usrCache.isExpandedModel {
            assignCellHeaderValues(cell: cellView, indexPath: indexPath)
            assignCellDetailValues(cell: cellView, indexPath: indexPath)
        }
        else {
            assignCellHeaderValues(cell: cellView, indexPath: indexPath)
        }
    }
    
    private func assignCellDetailValues(cell: DeviceTableViewCell, indexPath: IndexPath) {
        let cellViewModel = self.scanningDevicePageViewModel.deviceTableCellViewModelList[indexPath.row]
        setLabelView(cell, cellViewModel: cellViewModel)
        var showWarning = true
        if cellViewModel.completeLocalName == Symbols.NOT_AVAILABLE {
            cell.CompleteLocalName.text = nil
            cell.CompleteLocalNameLabel.text = nil
        } else {
            cell.CompleteLocalNameLabel.text = "Complete Local Name: "
            cell.CompleteLocalName.text = cellViewModel.completeLocalName
            showWarning = false
        }
        if cellViewModel.txPowerLevel == Symbols.NOT_AVAILABLE {
            cell.TxPowerLevel.text = nil
            cell.TxPowerLevelLabel.text = nil
        } else {
            cell.TxPowerLevel.text = cellViewModel.txPowerLevel
            cell.TxPowerLevelLabel.text = "Tx Power: "
            showWarning = false
        }
        if cellViewModel.serviceUUIDDescription == Symbols.NOT_AVAILABLE {
            cell.serviceUUID.text = nil
            cell.ServiceUUIDLabel.text = nil
        } else {
            cell.serviceUUID.text = cellViewModel.serviceUUIDDescription
            cell.ServiceUUIDLabel.text = "Service UUID: "
            showWarning = false
        }
        if cellViewModel.solicitedServiceUUIDString == Symbols.NOT_AVAILABLE {
            cell.solicitedServiceUUID.text = nil
            cell.SolicitedServiceUUIDLabel.text = nil
        } else {
            cell.solicitedServiceUUID.text = cellViewModel.solicitedServiceUUIDString
            cell.SolicitedServiceUUIDLabel.text = "Solicited Service UUID: "
            showWarning = false
        }
        if cellViewModel.overflowServiceUUIDDescription == Symbols.NOT_AVAILABLE {
            cell.OverflowServiceUUID.text = nil
            cell.OverflowServiceUUIDLabel.text = nil
        } else {
            cell.OverflowServiceUUID.text = cellViewModel.overflowServiceUUIDDescription
            cell.OverflowServiceUUIDLabel.text = "Overflow Service UUID: "
            showWarning = false
        }
        if cellViewModel.manufacturerData.rawStringFormat == Symbols.NOT_AVAILABLE {
            cell.manufacturerData.text = nil
            cell.ManufacturerDataLabel.text = nil
        } else {
            cell.ManufacturerDataLabel.text = DeviceTableViewCell.ManufacturerDataButtonRestorationKey
            setupManufactureDataLabelPresentation(cell, cellViewModel: cellViewModel)
            updateManufactureDataField(cell, forCell: cellViewModel)
            cell.ManufacturerDataLabel.tag = indexPath.row
            showWarning = false
        }
        if cellViewModel.serviceData.rawStringFormat == Symbols.NOT_AVAILABLE {
            cell.serviceData.text = nil
            cell.ServiceDataLabel.text = nil
        } else {
            cell.ServiceDataLabel.text = DeviceTableViewCell.ServiceDataButtonRestorationKey
            setupServiceDataLabelPresentation(cell, cellViewModel: cellViewModel)
            updateServiceDataField(cell, forCell: cellViewModel)
            cell.ServiceDataLabel.tag = indexPath.row
            showWarning = false
        }
        if showWarning { cell.PlaceholderView.isHidden = false }
        else { cell.PlaceholderView.isHidden = true }
        cellViewModel.isVisualized = true
    }
    
    private func assignCellHeaderValues(cell: DeviceTableViewCell, indexPath: IndexPath) {
        let cellViewModel = self.scanningDevicePageViewModel.deviceTableCellViewModelList[indexPath.row]
        cell.deviceID = cellViewModel.deviceID
        cell.RowExpandButton.tag = indexPath.row
        cell.FavouriteButton.tag = indexPath.row
        cell.deviceName.text = cellViewModel.deviceName
        cell.isConnectable.text = cellViewModel.connectionStatus
        cell.PlaceholderView.isHidden = true
        if let format = userChoices[cellViewModel.deviceID], format.isFavourite == true {
            setIconFavouriteConstrains(cell, shouldHide: false)
        } else {
            setIconFavouriteConstrains(cell, shouldHide: true)
        }
        updateSignalInterval(cell, cellViewModel: cellViewModel)
        colorSetUpForIcon(cell, cellViewModel: cellViewModel)
        showHideConnectButton(cell, isConnectable: cellViewModel.isConnectable, indexPath: indexPath)
    }
    
    private func updateSignalInterval(_ cell: DeviceTableViewCell, cellViewModel: ScanningDevicePageCellViewModel) {
        if cellViewModel.isDeviceOutOfRange || !cellViewModel.isValidatedInterval || !cellViewModel.isSatisfiedForFilter {
            setRowColor(cell: cell, color: UIColor.lightGray)
            cell.deviceSignalStrengthen.text = cellViewModel.rssi
            cell.intervalValueLabel.text = cellViewModel.interval
        } else {
            setRowColor(cell: cell, color: UIColor.black)
            cell.deviceSignalStrengthen.text = cellViewModel.rssi
            cell.intervalValueLabel.text = cellViewModel.interval
        }
    }
    
    fileprivate func setRowColor(cell: DeviceTableViewCell, color: UIColor) {
        cell.deviceSignalStrengthen.textColor = color
        cell.intervalValueLabel.textColor = color
        cell.TxPowerLevel.textColor = color
    }
    
    fileprivate func setLabelView(_ cell: DeviceTableViewCell, cellViewModel: ScanningDevicePageCellViewModel) {
        if let data = cellViewModel.serviceData, data.hasMultiFormation {
            setupServiceDataLabelPresentation(cell, cellViewModel: cellViewModel)
        } else {
            deregisterServiceDataLabelPresentation(cell, cellViewModel: cellViewModel)
        }
        if let manufData = cellViewModel.manufacturerData, manufData.hasMultiFormation {
            setupManufactureDataLabelPresentation(cell, cellViewModel: cellViewModel)
        } else {
            deregisterManufactureDataLabelPresentation(cell, cellViewModel: cellViewModel)
        }
    }
    
    private func updateManufactureDataField(_ cell: DeviceTableViewCell, forCell viewModel: ScanningDevicePageCellViewModel) {
        guard let cache = self.userChoices[viewModel.deviceID] else { return }
        switch cache.chosenFormatManufacturerData {
        case .beaconData:
            cell.manufacturerData.text = viewModel.manufacturerData.beaconDataFormatedString
        case .manufacturerData4_1:
            cell.manufacturerData.text = viewModel.manufacturerData.manufactureData4_1FormatedString
        case .manufacturerDataBytes:
            cell.manufacturerData.text = viewModel.manufacturerData.rawStringFormat
        default:
            cell.manufacturerData.text = viewModel.manufacturerData.rawStringFormat
        }
    }
    
    private func updateServiceDataField(_ cell: DeviceTableViewCell, forCell viewModel: ScanningDevicePageCellViewModel) {
        guard let cache = self.userChoices[viewModel.deviceID] else { return }
        switch cache.chosenFormatServiceData {
            case .eddystone:
                cell.serviceData.text = viewModel.serviceData.eddystoneFormatedString
            case .serviceDataBytes:
                cell.serviceData.text = viewModel.serviceData.rawStringFormat
            default:
                cell.serviceData.text = viewModel.serviceData.rawStringFormat
        }
    }
    
    fileprivate func setUpIconBackground(_ cell: DeviceTableViewCell, displayColor: UIColor?, alphaMiddleLayer: CGFloat) {
        cell.IconBackground.backgroundColor = displayColor
        cell.IconBackground.layer.cornerRadius = 20
        cell.IconMiddleBackground.layer.cornerRadius = 20
        cell.IconMiddleBackground.alpha = alphaMiddleLayer
        cell.IconMiddleBackground.clipsToBounds = true
        cell.IconBackground.clipsToBounds = true
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
    
    fileprivate func showHideConnectButton(_ cell: DeviceTableViewCell, isConnectable: Bool?, indexPath: IndexPath) {
        if let result = isConnectable , result == true {
            cell.isConnectable.text = self.scanningDevicePageViewModel.CONNECTABLE
            cell.ConnectPeripheralButton.isHidden = false
            cell.ConnectPeripheralButton.layer.cornerRadius = 0.05*cell.ConnectPeripheralButton.bounds.size.width
            cell.ConnectPeripheralButton.clipsToBounds = true
            cell.ConnectPeripheralButton.tag = indexPath.row
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
        } else {
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
        setFavouriteButton(isFavourite: !showingFav)
    }
    
    private func setFavouriteFilter() {
        self.scanningDevicePageViewModel.filterSettings.showOnlyFavourite = self.FavouriteFilterButton.tag != 0 ? true : false
        if self.scanningDevicePageViewModel.filterSettings.showOnlyFavourite {
            for (key, value) in self.userChoices {
                if value.isFavourite {
                    self.scanningDevicePageViewModel.filterSettings.favourite.append(key)
                }
            }
        }
    }
    
    fileprivate func setFavouriteButton(isFavourite: Bool) {
        if isFavourite {
            let image = UIImage(named: "ic_radio_button_checked_blue") as UIImage?
            self.FavouriteFilterButton.setImage(image, for: UIControlState())
            self.FavouriteFilterButton.tag = 1
        } else {
            let image = UIImage(named: "ic_radio_button_unchecked_blue") as UIImage?
            self.FavouriteFilterButton.setImage(image, for: UIControlState())
            self.FavouriteFilterButton.tag = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nameFilter = (self.NameFilterTextField.text)?.trimmingCharacters(in: CharacterSet.whitespaces)
        let deviceTypeFilter = self.RawDataFilterTextField.text
        let rssiFilter = getRssiValue()
        self.scanningDevicePageViewModel.setNewDeviceFilter()
        self.scanningDevicePageViewModel.filterSettings.nameFilter = nameFilter!
        self.scanningDevicePageViewModel.filterSettings.deviceTypeFilter = DeviceTypeFilterEnum.getDeviceType(deviceTypeFilter!)
        self.scanningDevicePageViewModel.filterSettings.rssi = Float(rssiFilter)
        setFavouriteFilter()
        guard validateFilter() else { return false }
        CleanTableViewForFilter()
        resetFilterViewHeight()
        return true
    }
    
    private func CleanTableViewForFilter() {
        stopDeviceUpdateTimer()
        self.scanningDevicePageViewModel.clearDataSource()
        if self.scanningDevicePageViewModel.didDataSourceChanged {
            self.deviceTableView.reloadData()
            self.scanningDevicePageViewModel.didDataSourceChanged = !self.scanningDevicePageViewModel.didDataSourceChanged
        }
        updateDeviceTableView()
        if self.scanningDevicePageViewModel.scanButtonStatus == .scanning {
            fireDeviceUpdateTimer()
        }
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
    
    func validateFilter() -> Bool {
        guard self.scanningDevicePageViewModel.isFilterValidate() else {
            FilterLabel.text = self.scanningDevicePageViewModel.filterSettings.NO_FILTER
            return false
        }
        FilterLabel.text = self.scanningDevicePageViewModel.filterSettings.description()
        self.FilterClearButtonWidth.constant = 44
        return true
    }
    
    @IBAction func FilterClearButtonPressed(_ sender: UIButton) {
        FilterLabel.text = self.scanningDevicePageViewModel.filterSettings.NO_FILTER
        self.FilterClearButtonWidth.constant = 0
        self.scanningDevicePageViewModel.turnOffDeviceFilters()
        let defaultValues = self.scanningDevicePageViewModel.filterSettings
        NameFilterTextField.text = defaultValues.nameFilter
        RawDataFilterTextField.text = defaultValues.deviceTypeFilter.description()
        RSSIFilterSlider.value = defaultValues.rssi
        RSSIFilterSliderValue.text = defaultValues.rssiString()
       CleanTableViewForFilter()
    }
    
    @IBAction func FavouriteButtonPressed(_ sender: UIButton) {
        guard sender.tag < self.scanningDevicePageViewModel.deviceTableCellViewModelList.count else { return }
        let indexOfSelectedRow = getIndexPath(sender.tag)
        let cellView = findCellInView(indexOfSelectedRow.row)
        let cellViewModel = self.scanningDevicePageViewModel.deviceTableCellViewModelList[indexOfSelectedRow.row]
        guard let item = self.userChoices[cellViewModel.deviceID] else {
            let choice = UserChoiceOnDevice(indexOfSelectedRow)
            choice.isFavourite = true
            setIconFavouriteConstrains(cellView!, shouldHide: false)
            self.userChoices[cellViewModel.deviceID] = choice
            return
        }
        if item.isFavourite {
            setIconFavouriteConstrains(cellView!, shouldHide: true)
            //In this case the view is in filter mode and user want to remove any of the favourited device, we need update filter
            if self.scanningDevicePageViewModel.removeFavroutiteDeviceFromFilterList(cellViewModel.deviceID) {
                reloadRowAt(indexOfSelectedRow.row)
            }
        } else {
            setIconFavouriteConstrains(cellView!, shouldHide: false)
            //reset cached height for the row
        }
        item.isFavourite = !item.isFavourite
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
                cellView.IconFavouriteTopIconBackgroundBottomConstrain.constant = -1
                cellView.IconFavouriteHeight.constant = 11
            } else if AppInfo.deviceModel == .pad {
                cellView.iPadIconFavouriteTopIconBackgroundBottomConstrain.constant = -1
                cellView.iPadIconFavouriteHeight.constant = 11
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

