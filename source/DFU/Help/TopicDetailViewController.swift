//
//  TopicDetailPage.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 08/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

class TopicDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var topicDetailTableView: UITableView!
    var topicDetailViewModel = TopicDetailViewModel()
    
    override func viewDidLoad() {
        self.topicDetailTableView.delegate = self
        self.topicDetailTableView.dataSource = self
        topicDetailTableView.rowHeight = UITableViewAutomaticDimension
        topicDetailTableView.estimatedRowHeight = 40
        self.topicDetailTableView.separatorStyle = .singleLine
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TopicDetailTableCellViewController = self.topicDetailTableView.dequeueReusableCell(withIdentifier: "TopicDetailTableCell") as! TopicDetailTableCellViewController
        let cellVM = self.topicDetailViewModel.topicDetails[indexPath.row]
        if !cellVM.hasSubTopic {
            cell.accessoryType = .none
        }
        if cellVM.topicType == .Image {
            cell.topicImage.image = cellVM.image
            cell.topicDescription.isHidden = true
            cell.LinksButton.isHidden = true
        } else if cellVM.topicType == .Text {
            cell.topicDescription.text = cellVM.topic
            cell.topicImage.isHidden = true
            cell.LinksButton.isHidden = true
        } else if cellVM.topicType == .Hyperlink {
            cell.LinksButton.setTitle(cellVM.topic, for: .normal)
            cell.LinksButton.addTarget(self, action: #selector(TopicDetailViewController.hyperlinkPressed), for: .touchUpInside)
            cell.LinksButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
            cell.LinksButton.tag = indexPath.row
            cell.topicImage.isHidden = true
            cell.topicDescription.isHidden = true
        }
        return cell
    }
    
    @objc func hyperlinkPressed(_ sender: UIButton) {
        let cellVM = self.topicDetailViewModel.topicDetails[sender.tag]
        let url = NSURL(string: cellVM.topic)!
        UIApplication.shared.openURL(url as URL)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topicDetailViewModel.topicDetails.count
    }

    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        if self.topicDetailViewModel.topicDetails[indexPath.row].image == nil {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return action == #selector(copy(_:))
    }
    
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if action == #selector(copy(_:)) {
            if let content = self.topicDetailViewModel.topicDetails[indexPath.row].topic {
                UIPasteboard.general.string = content
            }
        }
    }
}
