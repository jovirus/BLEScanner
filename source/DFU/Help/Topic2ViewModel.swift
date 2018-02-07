//
//  Topic2ViewModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 08/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
class Topic2ViewModel {
    var topics: [Topic2TableCellViewModel] = []
    private(set) var parentTopic: TopicTableCellViewModelBase!
    private(set) var selectedRow: TopicTableCellViewModelBase!

    init() {
        
    }
    
    func setTopic(parentTopic: TopicTableCellViewModelBase) {
        self.parentTopic = parentTopic
        for item in self.parentTopic.subTopics {
                let cellVM = Topic2TableCellViewModel()
                cellVM.topic = item.topic
                cellVM.topicID = item.id
                cellVM.topicType = item.topicType
                if item.sections.count > 0 {
                    cellVM.hasSubTopic = true
                    cellVM.subTopics = item.sections
                } else {
                    cellVM.hasSubTopic = false
            }
                topics.append(cellVM)
            }
    }
    
    func setSelectedRow(atRow: Int) {
        self.selectedRow = self.topics[atRow]
    }
}
