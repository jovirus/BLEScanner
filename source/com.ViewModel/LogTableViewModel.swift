//
//  LogTableViewModel.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 13/04/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation

extension LogTableViewModel {

    public enum updateMode: Int {
        case manually = 0
        case automaticly = 1
        case filterMode = 2
    }
    
    public enum updateStatus: Int {
        case not_updating = 0
        case updating = 1
    }
    
    func changeUpdateStatus(updateStatus: updateStatus) {
        self.status = updateStatus
    }
}

class LogTableViewModel: ViewModelBase {
    
    private let className = String(describing: LogTableViewModel.self)
    fileprivate(set) var viewRecords = SynchronizedArray<Log>(debug: "#viewRecords")
    fileprivate(set) var newRecords = SynchronizedArray<Log>(debug: "#newRecords")
    fileprivate(set) var filterRecords = SynchronizedArray<Log>(debug: "#filterRecords")
    fileprivate(set) var chosenUpdateMode: updateMode = .automaticly
    fileprivate(set) var status: updateStatus = .not_updating
    fileprivate(set) var selectedDevice: BLEDevice!
    fileprivate(set) var session: BLESession!
    var userFilter: LogType!
    
    override init() {
        super.init()
    }
    
    func setNewRecord(log: Log) {
        newRecords.append(log)
    }
    
    private func initializeViewRecords() -> Bool {
        viewRecords.removeAll()
        newRecords.removeAll()
        guard let result = LogManager.instance.getLog(session: self.session) else { return false }
        viewRecords.append(result)
        return true
    }
    
    func setSelectedDevice(_ device: BLEDevice, session: BLESession) {
        self.selectedDevice = device
        self.session = session
    }

    
    func setUpdatedMode (updateMode: updateMode) {
        self.chosenUpdateMode = updateMode
    }
    
    func getFilteredLog(completion: @escaping ((Bool) -> Void)) {
        guard chosenUpdateMode == .filterMode, userFilter != nil else {
            return completion(false)
        }
        guard let result = LogManager.instance.getLogByType(self.userFilter, session: self.session) else {
            return completion(false)
        }
        self.filterRecords.removeAll { (before) in
            self.filterRecords.append(result)
            completion(true)
        }
    }

    func performAutoUpdate(completion: @escaping ((Bool) -> Void)) {
        guard self.chosenUpdateMode == .automaticly else {
            return completion(false)
        }
        changeUpdateStatus(updateStatus: .updating)
        updateLog { (true) in
            completion(true)
        }
    }
    
    private func updateLog(completion: @escaping ((Bool) -> Void)) {
        
        guard let _ = self.newRecords.first else {
            return completion(false)
        }
//        guard let log = LogManager.instance.getLog(id: firstRecord.index, session: self.session) else {
//            //Log the error
//            return false
//        }
        newRecords.removeFirst { (elements) in
            self.viewRecords.append(elements)
            completion(true)
        }
    }
    
    @discardableResult
    func performManualUpdate() -> Bool {
//        updateComplete()
        guard self.chosenUpdateMode == .manually else {
            return false
        }
        changeUpdateStatus(updateStatus: .updating)
        return initializeViewRecords()
    }
    
    func updateComplete() {
        changeUpdateStatus(updateStatus: .not_updating)
    }
}
