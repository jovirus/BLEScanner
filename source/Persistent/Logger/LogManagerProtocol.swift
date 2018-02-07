//
//  LogManagerProtocol.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 20/03/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
protocol LogManagerProtocol: DataAccessManagerProtocol {
    func addLog(_ message: String, logType: LogType, object: String, session: BLESession) -> Bool
    func getLogByType(_ type: LogType, session: BLESession) -> [Log]?
    func getLog(session: BLESession) -> [Log]?
    func getAllRecords(session: BLESession) -> String?
}
