//
//  TutorialPageViewController.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 23/06/16.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit

protocol TutorialPageViewControllerDelegate: class {
    
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageIndex index: Int)
}

extension TutorialPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                                               previousViewControllers: [UIViewController],
                                               transitionCompleted completed: Bool) {
        notifyTutorialDelegateOfNewIndex()
    }
}

class TutorialPageViewController : UIPageViewController {
    weak var tutorialDelegate: TutorialPageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        //dataSource = self
        if let initialViewController = orderedViewControllers.first {
            scrollToViewController(initialViewController)
        }
        tutorialDelegate?.tutorialPageViewController(self,
                                                     didUpdatePageCount: orderedViewControllers.count)
    }
    
    /**
     Scrolls to the given 'viewController' page.
     
     - parameter viewController: the view controller to show.
     */
    fileprivate func scrollToViewController(_ viewController: UIViewController,
                                        direction: UIPageViewControllerNavigationDirection = .forward) {
        setViewControllers([viewController],
                           direction: direction,
                           animated: true,
                           completion: { (finished) -> Void in
                            // Setting the view controller programmatically does not fire
                            // any delegate methods, so we have to manually notify the
                            // 'tutorialDelegate' of the new index.
                            self.notifyTutorialDelegateOfNewIndex()
        })
    }
    
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.initialTutorialViewController("AppInformationPage")]
    }()
    
    fileprivate func initialTutorialViewController(_ tutorialPageName: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "\(tutorialPageName)ViewController")
    }
    
    /**
     Notifies '_tutorialDelegate' that the current page index was updated.
     */
    fileprivate func notifyTutorialDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.index(of: firstViewController) {
            tutorialDelegate?.tutorialPageViewController(self,
                                                         didUpdatePageIndex: index)
        }
    }
    
//    /**
//     Scrolls to the next view controller.
//     */
//    func scrollToNextViewController() {
//        if let visibleViewController = viewControllers?.first,
//            let nextViewController = pageViewController(self,
//                                                        viewControllerAfterViewController: visibleViewController) {
//            scrollToViewController(nextViewController)
//        }
//    }
    
    /**
//     Scrolls to the view controller at the given index. Automatically calculates
//     the direction.
//     
//     - parameter newIndex: the new index to scroll to
//     */
//    func scrollToViewController(index newIndex: Int) {
//        if let firstViewController = viewControllers?.first,
//            let currentIndex = orderedViewControllers.indexOf(firstViewController) {
//            let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .Forward : .Reverse
//            let nextViewController = orderedViewControllers[newIndex]
//            scrollToViewController(nextViewController, direction: direction)
//        }
//    }
}

// MARK: UIPageViewControllerDataSource

//extension TutorialPageViewController: UIPageViewControllerDataSource {
//    
//    func pageViewController(pageViewController: UIPageViewController,
//                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
//        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
//            return nil
//        }
//        
//        let previousIndex = viewControllerIndex - 1
//        
//        // User is on the first view controller and swiped left to loop to
//        // the last view controller.
//        guard previousIndex >= 0 else {
//            return orderedViewControllers.last
//        }
//        
//        guard orderedViewControllers.count > previousIndex else {
//            return nil
//        }
//        
//        return orderedViewControllers[previousIndex]
//    }
//    
//    func pageViewController(pageViewController: UIPageViewController,
//                            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
//        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
//            return nil
//        }
//        
//        let nextIndex = viewControllerIndex + 1
//        let orderedViewControllersCount = orderedViewControllers.count
//        
//        // User is on the last view controller and swiped right to loop to
//        // the first view controller.
//        guard orderedViewControllersCount != nextIndex else {
//            return orderedViewControllers.first
//        }
//        
//        guard orderedViewControllersCount > nextIndex else {
//            return nil
//        }
//        
//        return orderedViewControllers[nextIndex]
//    }

//}
