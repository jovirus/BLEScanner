//
//  PersistentRelation.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 04/04/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
internal class Relation<S: EntityObject, R: EntityObject>: EntityObject {
    var subject: S
    var relation: R
    
    init(subject: S, relation: R) {
        self.subject = subject
        self.relation = relation
    }
}
