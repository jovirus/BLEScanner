//
//  HelperPageTopicViewModel.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 07/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
class Topic1ViewModel {
    var topics: [Topic1TableCellViewModel] = []
    private(set) var selectedRow: TopicTableCellViewModelBase!
    
    init() {
        getTopic()
    }
    
    func getTopic() {
        if let docs = AppInitializer.topicDocs {
            for item in docs.sections {
                let cellVM = Topic1TableCellViewModel()
                cellVM.topic = item.topic
                cellVM.topicID = item.id
                cellVM.topicType = item.topicType
                if item.sections.count > 0 {
                    cellVM.hasSubTopic = true
                    cellVM.subTopics = item.sections
                } else
                {
                    cellVM.hasSubTopic = false
                }
                topics.append(cellVM)
            }
        }
    }
    
    func setSelectedRow(atRow: Int) {
        self.selectedRow = self.topics[atRow]
    }
}
