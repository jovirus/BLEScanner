//
//  AppInitializer.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 02/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
class AppInitializer {
    fileprivate static let companyIDurl = URL(string: "https://www.dropbox.com/s/0jskfctrown3pvu/company_id_v201711.json?dl=1")
    
    static var topicDocs: TopicModel!

    internal static func installCompanyInfo() {
        if let result = LocalAccessManager.instance.readCompanyInfoFile((companyIDurl?.lastPathComponent)!) {
            PersistentObjectManager.instance.companyIDListPersist.companies = result
        }
        else {
            guard AppConnectionManager.instance.isReachable else { return }
            ServerAccessManager.instance.loadFileAsync(companyIDurl!, completion: {(path, error) in
                guard error == nil else { return }
                guard let result = LocalAccessManager.instance.readCompanyInfoFile(path.lastPathComponent) else { return }
                PersistentObjectManager.instance.companyIDListPersist.companies = result
            })
        }
    }
    
    internal static func installDFUHelpDoc() {
        DispatchQueue.main.async {
            let dfuHelpDoc: [String: AnyObject]!
            dfuHelpDoc = LocalAccessManager.instance.getDFUHelpDocuments()
            self.topicDocs = TopicModel()
            if dfuHelpDoc != nil {
                _ = getTreeDoc(docs: dfuHelpDoc, topics: topicDocs)
            }
        }
    }
    
    fileprivate static func getTreeDoc(docs: [String: AnyObject], topics: TopicModel) -> TopicModel {
        guard docs.count > 0 else {
            return topics
        }
        for title in docs.keys.ascending() {
            let newTopic = TopicModel()
            newTopic.setTopic(description: title)
            if let subSection = docs[title], subSection.count != nil {
                let value = getTreeDoc(docs: subSection as! [String : AnyObject], topics: newTopic)
                topics.sections.append(value)
            }
            else {
                topics.sections.append(newTopic)
            }
        }
        return topics
    }
}
