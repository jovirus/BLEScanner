//
//  HelpPageViewController.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 01/12/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

class Topic1ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var topicsTableView: UITableView!
    var topic1ViewModel: Topic1ViewModel = Topic1ViewModel()
    
    override func viewDidLoad() {
        topicsTableView.delegate = self
        topicsTableView.dataSource = self
        topicsTableView.rowHeight = UITableViewAutomaticDimension
        topicsTableView.estimatedRowHeight = 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Topic1TableCellViewController = self.topicsTableView.dequeueReusableCell(withIdentifier: "Topic1TableCell") as! Topic1TableCellViewController
        let cellVM = self.topic1ViewModel.topics[indexPath.row]
        cell.topic.text = cellVM.topic
        if !cellVM.hasSubTopic {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topic1ViewModel.topics.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let postonedVC = segue.destination as! Topic2ViewController
        if self.topic1ViewModel.selectedRow.hasSubTopic {
            postonedVC.topic2ViewModel.setTopic(parentTopic: self.topic1ViewModel.selectedRow)
        } else {
            //STOP A SEGUE
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        self.topic1ViewModel.setSelectedRow(atRow: (self.topicsTableView.indexPathForSelectedRow?.row)!)
        if !self.topic1ViewModel.selectedRow.hasSubTopic {
            return false
        } else
        {
            return true
        }
    }
}
