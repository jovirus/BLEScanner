//
//  AlertViewController.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 11/01/2017.
//  Copyright © 2017 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

class AlertViewController: UIViewController {
    
    var alertViewControllerProtocol: AlertViewController?
    func showAlert() {
        let errorAlert = UIAlertController(title: "File exist", message: "The selected file has already in your firmware list.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            //
        }
        errorAlert.addAction(okAction)
        alertViewControllerProtocol?.present(errorAlert, animated: true, completion: nil)
    }
}
