//
//  TopicDetailViewModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 08/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit
class TopicDetailViewModel {
    var topicDetails: [TopicDetailTableCellViewModel] = []
    private(set) var parentTopic: TopicTableCellViewModelBase!
    
    init() {
    }
    
    func setTopic(parentTopic: TopicTableCellViewModelBase) {
        self.parentTopic = parentTopic
        for item in self.parentTopic.subTopics {
            let cellVM = TopicDetailTableCellViewModel()
            cellVM.topic = item.topic
            cellVM.topicID = item.id
            cellVM.topicType = item.topicType
            if item.sections.count == 0 {
                cellVM.hasSubTopic = false
                topicDetails.append(cellVM)
            } else {
                cellVM.hasSubTopic = true
            }
    }
  }
}
