//
//  Topic2ViewController.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 08/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

class Topic2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var topic2TableView: UITableView!
    var topic2ViewModel = Topic2ViewModel()
    
    override func viewDidLoad() {
        self.topic2TableView.delegate = self
        self.topic2TableView.dataSource = self
        topic2TableView.rowHeight = UITableViewAutomaticDimension
        topic2TableView.estimatedRowHeight = 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Topic2TableCellViewController = self.topic2TableView.dequeueReusableCell(withIdentifier: "Topic2TableCell") as! Topic2TableCellViewController
        let cellVM = self.topic2ViewModel.topics[indexPath.row]
        cell.Topic2.text = cellVM.topic
        if !cellVM.hasSubTopic {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topic2ViewModel.topics.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let postonedVC = segue.destination as! TopicDetailViewController
        if self.topic2ViewModel.selectedRow.hasSubTopic {
            postonedVC.topicDetailViewModel.setTopic(parentTopic: self.topic2ViewModel.selectedRow)
        } else {
            //STOP A SEGUE
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        self.topic2ViewModel.setSelectedRow(atRow: (self.topic2TableView.indexPathForSelectedRow?.row)!)
        if !self.topic2ViewModel.selectedRow.hasSubTopic {
            return false
        } else
        {
            return true
        }
    }
}
