//
//  SecurityDFUFilePersist.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 11/01/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import EVReflection

class UserFirmwarePersist: EVObject {
    var savedAt: Date?
//    var firmwareURL: URL?
    var firmwareName: String?
    var firmwareSize: UInt64?
    var firmwareKind: DFUFileKind?
    var firmwareType: DFUFirmwareTypeEnum?
//    var firmwareDatURL: URL?
    var firmwareDatName: String?
    
    override func propertyConverters() -> [(key: String, decodeConverter: ((Any?) -> ()), encodeConverter: (() -> Any?))] {
        return [(
            "firmwareKind",
            { self.firmwareKind = DFUFileKind.getValue(type: $0 as! String) },
            { return self.firmwareKind?.rawValue }),
                ("firmwareSize",
                 { self.firmwareSize = UInt64($0 as! UInt64) },
                 { return self.firmwareSize }
            ),
                ("firmwareType",
                 { self.firmwareType = DFUFirmwareTypeEnum.convertValue(dfuFirmwareTypeEnum: $0 as! String) },
                 { return self.firmwareType?.rawValue }
            ),
                ("savedAt",
                 { self.savedAt = Date(dateString: $0 as! String) },
                 { return self.savedAt!.fileViewFormat }
            )]
    }
}

class UserFirmwareListPersist: EVObject {
    var firmwareList: [UserFirmwarePersist]?
}

