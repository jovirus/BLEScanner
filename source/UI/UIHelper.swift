//
//  UIHelper.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 21/03/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
import UIKit

open class UIHelper
{
    static let screenSize = UIScreen.main.bounds.size
    static let screenRect = UIScreen.main.bounds
    static let screenWidth = screenSize.width
    static let screenHeight = screenSize.height
    
    static fileprivate var counter = 0
    static fileprivate var colors: [UIColor] = [UIColor.init(hexString: "FF0000"),
                                     UIColor.init(hexString: "2323F1"),
                                     UIColor.init(hexString: "C8841A"),
                                     UIColor.init(hexString: "27C32B"),
                                     UIColor.init(hexString: "45A1FF"),
                                     UIColor.init(hexString: "ACB117"),
                                     UIColor.init(hexString: "B1179D"),
                                     UIColor.init(hexString: "DCE31F"),
                                     UIColor.init(hexString: "47392D"),
                                     UIColor.init(hexString: "1AC8B1"),
                                     UIColor.init(hexString: "A42A2A"),]
    
    static func getRandomDeviceColorTag() -> UIColor {
        var color: UIColor!
        var colorPointer = 0
        colorPointer = Int.random(0, upper: self.colors.count - 1)
        color = colors[colorPointer]
        return color
    }
    
    static func getSequencedDeviceColorTag() -> UIColor {
        let colorIndex = counter%colors.count as Int
        let color = colors[colorIndex]
        self.counter += 1
        return color
    }
    
    static func resetColorCounter() {
        self.counter = 0
    }
    
    static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
