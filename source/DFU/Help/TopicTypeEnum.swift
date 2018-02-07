//
//  TopicTypeEnum.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 09/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation

enum TopicType: String {
    case Text = "[Text]"
    case Image = "[Image]"
    case Hyperlink = "[Hyperlink]"
    
    static func getType(value: String) -> TopicType! {
        var result: TopicType!
        switch value {
            case "[Text]":
                result = .Text
            case "[Image]":
                result = .Image
            case "[Hyperlink]":
                result = .Hyperlink
            default:
                break
        }
        return result
    }
}
