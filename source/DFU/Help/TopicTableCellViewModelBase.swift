//
//  HelpPageCellViewModelBase.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 01/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

class TopicTableCellViewModelBase {
    internal var topicID: String!
    internal var parentID: String!
    internal var hasSubTopic: Bool = false
    //Text contents for text descriptions, image name, button link
    internal var topic: String!
    internal var subTopics: [TopicModel]!
    internal var image: UIImage?
    internal var topicType: TopicType? {
        didSet {
                switch self.topicType! {
                    case TopicType.Image:
                        let image = UIImage(named: self.topic)! as UIImage
                        self.image = image
                default:
                        break
                }
            }
    }
}
