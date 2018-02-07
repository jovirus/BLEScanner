//
//  SpecificationView.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 12/10/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import EVReflection

protocol SpecificationViewProtocol {
//    associatedtype DataType
    //data offset also it used as an id specificly in the data list
    var offset: Int { get set}
    //data length
    var length: Int? { get }
    //length bytes requirement
    var dataLengthRange: Range<Int> { get set }
    //data description
    var description: String { get set}
    //data
    var data: [Any] { get }
    //data status will be set after the data field is filled
    var dataStatus: DataCalibrationStatus { get }
    //Whether the specification is a mandatory requirement
    var isMandatory: Bool { get }
    //data update
    mutating func updateData(data: [Any], description: String, validator: Validator)
    // validator to be used to check the data
    associatedtype Validator
}

enum DataCalibrationStatus: UInt8 {
    //used when no validator specified
    case unable_vertify = 0x00
    //used when initial the validator
    case will_verify = 0x01
    //used when data is valid by the given validator
    case verifiedValid = 0x02
    case verifiedInvalid = 0x03
}

class SpecificationView: SpecificationViewProtocol {
    typealias Validator = (SpecificationView) -> DataCalibrationStatus
    var offset: Int
    private(set) var length: Int?
    var dataLengthRange: Range<Int>
    var description: String
    private(set) var data = [Any]() {
        didSet {
            guard data.count > 0 else { return }
            dataStatus = dataInspector?(self) ?? DataCalibrationStatus.unable_vertify
            guard dataStatus == .verifiedValid else { return }
            self.length = self.data.count
        }
    }
    var dataStatus: DataCalibrationStatus = DataCalibrationStatus.unable_vertify
    lazy fileprivate var dataInspector: Validator? = {
        [unowned self] Validator in
        return DataCalibrationStatus.will_verify
    }
    var isMandatory: Bool
    
    init?(offset: Int, length: Int, dataLengthRange: Range<Int>, description: String, isMandatory: Bool, initialSubscription: Validator? = nil) {
        self.dataLengthRange = dataLengthRange
        guard self.dataLengthRange.contains(length) else { return nil }
        self.length = length
        self.offset = offset
        self.isMandatory = isMandatory
        self.description = description
        self.dataInspector = initialSubscription
    }

    init(offset: Int, dataLengthRange: Range<Int>, description: String, isMandatory: Bool, initialSubscription: Validator? = nil) {
        self.dataLengthRange = dataLengthRange
        self.offset = offset
        self.isMandatory = isMandatory
        self.description = description
        self.dataInspector = initialSubscription
    }

    init?(offset: Int, length: Int, dataLengthRange: Range<Int>, description: String, data: Any..., isMandatory: Bool, initialSubscription: @escaping Validator = {_ in return DataCalibrationStatus.will_verify}) {
        self.dataLengthRange = dataLengthRange
        guard self.dataLengthRange.contains(length) else { return nil }
        self.length = length
        self.offset = offset
        self.description = description
        self.data.append(contentsOf: data)
        self.isMandatory = isMandatory
        self.dataInspector = initialSubscription
    }
    
    func updateData(data: [Any], description: String = "", validator: @escaping Validator) {
        self.dataInspector = validator
        self.data.removeAll()
        self.data.append(contentsOf: data)
        guard description != "" else { return }
        self.description = description
    }
    
    func updateData(data: [Any], description: String = "") {
        self.data.removeAll()
        self.data.append(contentsOf: data)
        guard description != "" else { return }
        self.description = description
    }
}

extension SpecificationView {
    class func isEqual<T: Equatable>(type: T.Type, a: [Any], b: [Any]) -> Bool {
        guard a.count == b.count else { return false }
        // check all elements in a, b are same as specified type
        guard a.index(where: { (x) -> Bool in
            guard x as? T == nil else { return false }
            return true
        }) == nil && b.index(where: { (x) -> Bool in
            guard x as? T == nil else { return false }
            return true
        }) == nil else { return false }
        
        var isEqual = true
        for index in 0..<a.count {
            guard let ai = a[index] as? T, let bi = b[index] as? T else { return false }
            guard ai == bi else {
                isEqual = false
                return isEqual
            }
        }
        return isEqual
    }
}

