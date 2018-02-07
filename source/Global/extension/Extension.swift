//
//  Extension.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 10/08/15.
//  Copyright (c) 2015 Jiajun Qiu. All rights reserved.
//

import Foundation
import UIKit
extension Stack{
    var topItem: T?{
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

//extension Array{
//
//    func uniq(_ source: [String]) -> [String]
//    {
//        var buffer = [String]()
//        var added = Set<String>()
//        var extra = [String]()
//        for item in source {
//            if !added.contains(item)
//                {
//                    buffer.append(item)
//                    added.insert(item)
//                }
//                else
//                {
//                    extra.append(item)
//                }
//            }
//        return extra;
//    }
//    
//    func toStringResult() -> String
//    {
//        var result: String = ""
//        for item in self
//        {
//            let temp = item as! String;
//            result += temp + " "
//        }
//        return result;
//    }
//}

extension NSMutableAttributedString {
    func convertFontTo(_ font: UIFont) {
        var range = NSMakeRange(0, 0)
        while (NSMaxRange(range) < length)
        {
            let attributes = self.attributes(at: NSMaxRange(range), effectiveRange: &range)
            if let oldFont = attributes[NSAttributedStringKey.font]
            {
                let newFont = UIFont(descriptor: font.fontDescriptor.withSymbolicTraits((oldFont as AnyObject).fontDescriptor.symbolicTraits)!, size: font.pointSize)
                addAttribute(NSAttributedStringKey.font, value: newFont, range: range)
            }
        }
    }
}



extension String {
    var drop0xPrefix: String { return hasPrefix("0x") ? String(dropFirst(2)) : self }
    var drop0bPrefix: String { return hasPrefix("0b") ? String(dropFirst(2)) : self }
    var hexaToDecimal: Int! {
            return Int(drop0xPrefix, radix: 16)
    }
    var hexaToDecimalString: String! {
        guard let value = self.hexaToDecimal else { return nil }
        return String(value)
    }
    var hexaToInt8: Int8! {
        if !((Array(self.drop0xPrefix).map { (x) -> Bool in
            return x == "0" }).contains(false)) { return 0 }
        let result = Int8(truncatingIfNeeded: strtoul(drop0xPrefix, nil, 16))
        guard result != 0 else { return nil }
        return result
    }
    var hexaToInt8String: String! {
        guard let value = self.hexaToInt8 else { return nil }
        return String(value)
    }
    var hexaToBinaryString: String! {
        guard let value = self.hexaToDecimal else { return nil }
        return String(value, radix: 2)
    }
    var hexaToUInt8: UInt8! {
        guard let value = self.hexaToInt8 else { return nil }
        return UInt8(bitPattern: Int8(value))
    }
    var hexaToUInt8String: String! {
        guard let value = self.hexaToUInt8 else { return nil }
        return String(value)
    }
    var decimalToHexaString: String! {
        guard let value = Int(self) else { return nil }
        return String(value, radix: 16)
    }
    var decimalToBinaryString: String! {
        guard let result = Int(self) else { return nil }
        return String(Int(result) , radix: 2)
    }
    var binaryToDecimal: Int! {
        guard let value = Int(drop0bPrefix, radix: 2) else { return nil }
        return value
    }
    var binaryToHexaString: String! {
        guard let value = self.binaryToDecimal else { return nil }
        return String(value, radix: 16)
    }
    func containsIgnoringCase(_ input: String) -> Bool{
        return self.range(of: input, options: .caseInsensitive) != nil
    }
}

extension Float {
    /// Rounds the float to decimal places value
    mutating func roundToPlaces(_ places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Double {
    /// Rounds the double to decimal places value
    mutating func roundToPlaces(_ places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UInt32 {
    static func random(_ lower: UInt32 = min, upper: UInt32 = max) -> UInt32 {
//        return arc4random_uniform(upper - lower) + lower
        return UInt32.random(lower, upper: upper)
    }
}

extension Int32 {
    static func random(_ lower: Int32 = min, upper: Int32 = max) -> Int32 {
//        let r = arc4random_uniform(UInt32(Int64(upper) - Int64(lower)))
//        return Int32(Int64(r) + Int64(lower))
        return Int32.random(lower, upper: upper)
    }
}

//func arc4random <T: ExpressibleByIntegerLiteral> (_ type: T.Type) -> T {
//    var r: T = 0
//    arc4random_buf(&r, MemoryLayout<T>.size)
//    return r
//}

extension UInt64 {
    static func random(_ lower: UInt64 = min, upper: UInt64 = max) -> UInt64 {
//        var m: UInt64
//        let u = upper - lower
//        var r = arc4random(UInt64.self)
//
//        if u > UInt64(Int64.max) {
//            m = 1 + ~u
//        } else {
//            m = ((max - (u * 2)) + 1) % u
//        }
//
//        while r < m {
//            r = arc4random(UInt64.self)
//        }
//        return (r % u) + lower
        return UInt64.random(lower, upper: upper)
    }
}

extension Int64 {
    static func random(_ lower: Int64 = min, upper: Int64 = max) -> Int64 {
//        let (s, overflow) = Int64.subtractingReportingOverflow(upper)
//        let u = overflow ? UInt64.max - UInt64(~s) : UInt64(s)
//        let r = UInt64.random(upper: u)
//
//        if r > UInt64(Int64.max)  {
//            return Int64(r - (UInt64(~lower) + 1))
//        } else {
//            return Int64(r) + lower
//        }
        return Int64.random(lower, upper: upper)
    }
}

extension Int {
    static func random(_ lower: Int = min, upper: Int = max) -> Int {
//        switch (__WORDSIZE) {
//            case 32: return Int(Int32.random(Int32(lower), upper: Int32(upper)))
//            case 64: return Int(Int64.random(Int64(lower), upper: Int64(upper)))
//            default: return lower
//        }
        return Int.random(lower, upper: upper)
    }
}

infix operator ^
func ^ (radix: Double, power: Double) -> Double {
    return Double(pow(Double(radix), Double(power)))
}

//MARK: UI class extension

extension UIColor {
    public class func nordicBlue() -> UIColor
    {
        return UIColor(red: 0/255, green: 156/255, blue: 222/255, alpha: 1)
    }
    
    public class func nordicYellow() -> UIColor
    {
        return UIColor(red: 204/255, green: 204/255, blue: 0/255, alpha: 1)
    }
    
    public class func nordicGray() -> UIColor
    {
        return UIColor(red: 147/255, green: 149/255, blue: 151/255, alpha: 1)
    }
    
    public class func getRandomColor() -> UIColor {
        let randomRed:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomGreen:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomBlue:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    public convenience init(hexString: String, alpha: Double = 1.0) {
            let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            var int = UInt32()
            Scanner(string: hex).scanHexInt32(&int)
            let r, g, b: UInt32
            switch hex.count {
            case 3: // RGB (12-bit)
                (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
            default:
                (r, g, b) = (1, 1, 0)
            }
            self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(255 * alpha) / 255)
        }
}

extension NSMutableAttributedString {
    
    func setColorForStr(_ textToFind: String, color: UIColor) {
        
        let range = self.mutableString.range(of: textToFind, options:NSString.CompareOptions.caseInsensitive);
        if range.location != NSNotFound {
            self.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range);
        }
        
    }
}

extension Date {
    var logViewFormat: String! {
        let format = DateFormatter()
        format.dateFormat = "HH:mm:ss.SSS"
        return format.string(from: self)
    }
    
    var fileViewFormat: String! {
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy HH:mm"
//        format.dateStyle = .long
        return format.string(from: self)
    }
    
    var systemViewFormat: String {
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return format.string(from: self)
    }
    
    init(dateString: String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:date)
    }
}

private var HighlightedBackgroundColorKey = 0
private var NormalBackgroundColorKey = 0

extension UIButton {
    override open var isHighlighted: Bool {
        didSet {
            if let highlightedBackgroundColor = self.highlightedBackgroundColor {
                if isHighlighted {
                    backgroundColor = highlightedBackgroundColor
                } else {
                    backgroundColor = normalBackgroundColor
                }
            }
        }
    }
    
    @IBInspectable var highlightedBackgroundColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &HighlightedBackgroundColorKey) as? UIColor
        }
        
        set(newValue) {
            objc_setAssociatedObject(self,
                                     &HighlightedBackgroundColorKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    fileprivate var normalBackgroundColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &NormalBackgroundColorKey) as? UIColor
        }
        
        set(newValue) {
            objc_setAssociatedObject(self,
                                     &NormalBackgroundColorKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    override open var backgroundColor: UIColor? {
        didSet {
            if !isHighlighted {
                normalBackgroundColor = backgroundColor
            }
        }
    }
}


extension Sequence where Iterator.Element == String {
    func ascending() -> [String]{
        return sorted { $0 < $1 }
    }
}

extension RawRepresentable where RawValue == String {
    var description: String {
        return rawValue
    }
}

extension UITableView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        {
            _ in completion()
        }
    }
    
    func getIndexPath(_ cellIndex: Int) ->IndexPath
    {
        let indexPath = IndexPath(row: cellIndex, section: 0)
        return indexPath
    }
}
