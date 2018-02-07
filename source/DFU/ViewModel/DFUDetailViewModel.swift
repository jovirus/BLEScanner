//
//  DFUDashboardViewModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 23/11/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import CoreBluetooth
import iOSDFULibrary

protocol DFUDetailViewModelDelegate {
    func statusChanged(status: DFUStatus)
    func logUpdated(info: String)
    func timeCounterChanged(elapse: String)
    func didUpdateDFUProgress(currentBytesPerSec: Double, avgBytesPerSec: Double, progress: Int)
}

extension DFUDetailViewModel: DFUServiceDelegate {
    func dfuStateDidChange(to state: DFUState) {
        _ = logger.addLog(DFUOperationMessage.stateChanged.description + Symbols.whiteSpace + state.description(), logType: .debug, object: #function, session: self.session)
        switch state {
        case DFUState.completed:
            changeStatus(status: .Complete)
        case DFUState.aborted:
            changeStatus(status: .Abort)
        case DFUState.connecting:
            changeStatus(status: .Connecting)
        case DFUState.disconnecting:
            changeStatus(status: .Disconnecting)
        case DFUState.uploading:
            changeStatus(status: .Update)
        case DFUState.starting:
            changeStatus(status: .Start)
        default: break
        }
    }
    
    func dfuError(_ error: DFUError, didOccurWithMessage message: String) {
        self.status = .Abort
        _ = logger.addLog(DFUOperationMessage.errorOccurs.description + Symbols.whiteSpace + String(error.rawValue) + Symbols.whiteSpace + message, logType: .error, object: #function, session: self.session)
        self.dfuDetailViewModelDelegate?.statusChanged(status: self.status)
        self.dfuDetailViewModelDelegate?.logUpdated(info: message)
    }
}

extension DFUDetailViewModel: DFUProgressDelegate {
    func dfuProgressDidChange(for part: Int, outOf totalParts: Int, to progress: Int, currentSpeedBytesPerSecond: Double, avgSpeedBytesPerSecond: Double) {
        dfuDetailViewModelDelegate?.didUpdateDFUProgress(currentBytesPerSec: currentSpeedBytesPerSecond, avgBytesPerSec: avgSpeedBytesPerSecond, progress: progress)
        let message = "Updating" + Symbols.whiteSpace + String(progress) + Symbols.percentage
        self.dfuDetailViewModelDelegate?.logUpdated(info: message)
    }
}

extension DFUDetailViewModel: LoggerDelegate {
    public func logWith(_ level: LogLevel, message: String) {
        _ = logger.addLog(message, logType: .debug, object: String(describing: DFUMainViewModel.self), session: self.session)
    }
}

class DFUDetailViewModel: DFUViewModelBase {
    
    private(set) var dfuServiceController: DFUServiceController?
    fileprivate(set) var status: DFUStatus = .Ready
    private(set) var timeCounter: String!
    private(set) var timer: Timer!
    private(set) var estimatedTime: Int = 0
    fileprivate var count = 0
    fileprivate var second: Int!
    fileprivate var minute: Int!
    fileprivate var hour: Int!
    fileprivate var day: Int!
    fileprivate var updateInterval = TimeInterval(1.0)
    var dfuDetailViewModelDelegate: DFUDetailViewModelDelegate?

    internal var logger = LogManager.instance
    
    fileprivate(set) var playIcon = "ic_play_circle_filled_blue"
    fileprivate(set) var pauseIcon = "ic_pause_circle_filled_blue"
    fileprivate(set) var completeIcon = "ic_check_circle_blue"
    
    func isFirmwareReady() -> Bool {
        var isReady = false
        if self.firmware != nil {
            isReady = true
        }
        return isReady
    }
    
    internal func getfirmwareInfo() -> FirmwareInfoPopUpViewModel {
        let firmware = FirmwareInfoPopUpViewModel()
        firmware.addInfo(title: "File name:", value: self.firmwareName)
        firmware.addInfo(title: "Size:", value: self.firmwareSizeView)
        if self.firmwareKind == DFUFileKind.Binary {
            firmware.addInfo(title: "File kind:", value: DFUFileKind.Binary.rawValue)
            firmware.firmwareType = DFUFileKind.Binary
            let dfuFile = (self.dfuFile) as! LegacyDFUFile
            let binaryType = DFUFirmwareTypeEnum.getValue(type: dfuFile.firmwareType!).rawValue
            firmware.addInfo(title: "Type:", value: binaryType)
            if  let datName = dfuFile.firmwareDatName {
                let datFile = datName == "" ? Not_Available : datName
                firmware.addInfo(title: "Dat file:", value: datFile)
            }
        } else if self.firmwareKind == DFUFileKind.DistributionPackage {
            let dfuType = DFUFileKind.DistributionPackage.rawValue
            firmware.addInfo(title: "File kind:", value: dfuType)
            firmware.firmwareType = DFUFileKind.DistributionPackage
        }
        return firmware
    }
    
    func startUpdate() {
        guard let firmware = self.firmware else { return }
//        guardPeripheralConnected()
        let initiator = DFUServiceInitiator(centralManager: self.centralMananger, target: self.peripheral)
//        initiator.forceDfu = UserDefaults.standard.bool(forKey: "dfu_force_dfu")
//        initiator.packetReceiptNotificationParameter = UInt16(UserDefaults.standard.integer(forKey: "dfu_number_of_packets"))
//        initiator.forceDfu = true
//        initiator.packetReceiptNotificationParameter = 16
        initiator.logger = self
        initiator.delegate = self
        initiator.progressDelegate = self
        initiator.alternativeAdvertisingNameEnabled = UserPreference.instance.enableAlternativeName
        dfuServiceController = initiator.with(firmware: firmware).start()
    }
    
    func pauseUpdating() {
        guard self.status == .Update else {
            return
        }
        _ = logger.addLog(DFUOperationMessage.stateChanged.description, logType: .verbose, object: #function, session: self.session)
        self.dfuServiceController?.pause()
        changeStatus(status: .Pause)
    }
    
    fileprivate func startTimeCounter() {
       timer = Timer.scheduledTimer(timeInterval: updateInterval, target: self, selector: #selector(DFUDetailViewModel.updateTimeCounter), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimeCounter() {
        count += 1
        self.dfuDetailViewModelDelegate?.timeCounterChanged(elapse: toTimeFormat(count: count))
    }
    
    fileprivate func stopTimer() {
        self.timer.invalidate()
    }
    
    fileprivate func changeStatus(status: DFUStatus) {
        self.status = status
        if self.status == .Update {
            startTimeCounter()
        } else if self.status == .Complete || self.status == .Pause {
            stopTimer()
        }
        self.dfuDetailViewModelDelegate?.statusChanged(status: status)
    }
    
    internal func clearTimer() {
        self.timer.invalidate()
        self.count = 0
        self.minute = 0
        self.second = 0
        self.hour = 0
        self.day = 0
    }
    
    fileprivate func toTimeFormat(count: Int) -> String {
        self.second = count % 60
        self.minute = (count / 60) % 60
        self.hour = (count / 3600) % 24
        self.day = (count / 86400)
        return String(NSString(format: "%0.2d:%0.2d:%0.2d", hour,minute,second))
    }
    
    func getEstimatedTime() -> String {
        // calculate estimated time in second
        self.estimatedTime = Int(self.firmwareSize! / 1700)
        return toTimeFormat(count: self.estimatedTime)
    }
    
    func getdfuProgress() -> Float {
        var result = (Float(self.count) / Float(estimatedTime))
        return result.roundToPlaces(5)
    }
}
