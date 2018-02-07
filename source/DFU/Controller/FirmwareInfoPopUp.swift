//
//  FirmwareInfoViewController.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 04/01/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

class FirmwareInfoPopUp: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var firmwareName: UILabel!
    @IBOutlet weak var firmwareSize: UILabel!
    @IBOutlet weak var firmwareType: UILabel!
    @IBOutlet weak var binaryType: UILabel!
    @IBOutlet weak var datName: UILabel!
    @IBOutlet weak var binaryTypeLabel: UILabel!
    @IBOutlet weak var datFileLabel: UILabel!
    
    @IBOutlet weak var firmwareInfoTableView: UITableView!
    
    
    var firmwareInfoPopUpViewModel: FirmwareInfoPopUpViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        firmwareInfoTableView.rowHeight = UITableViewAutomaticDimension
        firmwareInfoTableView.estimatedRowHeight = firmwareInfoPopUpViewModel.estimatedRowHeight
    }
    
    override func viewDidLoad() {
        guard firmwareInfoPopUpViewModel != nil else {
            return
        }
        self.firmwareInfoTableView.delegate = self
        self.firmwareInfoTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "firmwareInfoCell", for: indexPath) as! FirmwareInfoCell
        let cellVM = firmwareInfoPopUpViewModel.firmwareInfoList[indexPath.row]
        cell.title.text = cellVM.title
        cell.title.textColor = UIColor.nordicBlue()
        cell.value.text = cellVM.value
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firmwareInfoPopUpViewModel.firmwareInfoList.count
    }
        
}
