//
//  TopicModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 01/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
class TopicModel {
    // title is always unique
    var id: String!
    var topicType: TopicType!
    var topic: String!
    private(set) var rawData: String!
    // var description: String!
//    var imageName: String!
    var sections: [TopicModel] = []
    
    private let separtor: Character = ";"
    private let idSegment: Int = 0
    private let typeSegment: Int = 1
    private let topicSegment: Int = 2
    
    func setTopic(description: String) {
        var result = description.split(separator: self.separtor)
        self.id = String(result[idSegment])
        self.topicType = TopicType.getType(value: String(result[typeSegment]) )
        self.topic = String(result[topicSegment])
    }
}
