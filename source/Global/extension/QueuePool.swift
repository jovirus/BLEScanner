//
//  QueuePool.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 10/10/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import Dispatch

//public enum QueuePool: String {
//    fileprivate static var pools = [String: DispatchQueue]()
//
//    case database = "io.zamzam.databaseQueue"
//    case transform = "io.zamzam.transformQueue"
//    case network = "io.zamzam.networkQueue"
//}
//
//extension QueuePool {
//    /**
//     Create dispatch queue.
//     */
//    func create() -> DispatchQueue {
//        let qos: DispatchQoS =
//            self == .database ? .utility
//                : self == .transform ? .userInitiated
//                : self == .network ? .userInitiated
//                : .background
//
////        return DispatchQueue(label: rawValue,
////            attributes: [.serial, qos]
////        )
//        DispatchQueue(label: self.rawValue, qos: qos, attributes: .concurrent, autoreleaseFrequency: .workItem, target: self)
//    }
//
//    /**
//     Submits a block for asynchronous execution on a dispatch queue.
//     */
//    func async(execute: DispatchWorkItem) {
//        let queue = QueuePool.pools[rawValue] ?? {
//            QueuePool.pools[rawValue] = $0
//            return $0
//            }(create())
//        queue.async(execute)
//    }
//}

