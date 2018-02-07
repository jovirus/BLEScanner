//
//  RearPageViewModel.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 25/04/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
import UIKit

internal enum RearPageViewEnum: Int {
    case logView = 0
    case graphView = 1
    //Deprecated
    case aboutView = 9
}

internal class RearPageViewModel: ViewModelBase {    
    var currentViewIndex = RearPageViewEnum.logView
    fileprivate(set) var topViewController: UIViewController!
    fileprivate(set) var graphViewController: RSSIChartViewController!
    fileprivate(set) var logViewController: LogViewController!

    func setTopViewController(vc: UIViewController) {
        self.topViewController = vc
    }
    
    func setGraphViewController(viewController: RSSIChartViewController) {
        self.graphViewController = viewController
    }
    
    func setLogViewController(viewController: LogViewController) {
        self.logViewController = viewController
    }
}
