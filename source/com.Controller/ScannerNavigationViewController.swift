//
//  MainNavigationViewController.swift
//  MasterControlPanel
//
//  Created by Mostafa Berg on 22/04/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import UIKit
import SWRevealViewController

class ScannerNavigationViewController: UINavigationController, UINavigationControllerDelegate {
    
    var revealGestureRecognizer: UIPanGestureRecognizer?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.delegate = self
        revealViewController().panGestureRecognizer().isEnabled = true
        revealGestureRecognizer = revealViewController().panGestureRecognizer()
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        addRevealGestureRecognizer(withView: viewController.view, andRecognizer: revealGestureRecognizer!)
    }
    
    func addRevealGestureRecognizer(withView aView : UIView, andRecognizer aRecognizer: UIGestureRecognizer) {
        aView.addGestureRecognizer(aRecognizer)
    }
}
