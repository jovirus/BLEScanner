////
////  BalloonMarker.swift
////  MasterControlPanel
////
////  Created by Jiajun Qiu on 03/06/16.
////  Copyright © 2016 Jiajun Qiu. All rights reserved.
////
//
//import Foundation
//import Charts;
//
//open class BalloonMarker: ChartMarker
//{
//    open var color: UIColor?
//    open var arrowSize = CGSize(width: 15, height: 11)
//    open var font: UIFont?
//    open var insets = UIEdgeInsets()
//    open var minimumSize = CGSize()
//    
//    fileprivate var labelns: NSString?
//    fileprivate var _labelSize: CGSize = CGSize()
//    fileprivate var _size: CGSize = CGSize()
//    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
//    fileprivate var _drawAttributes = [String : AnyObject]()
//    
//    public init(color: UIColor, font: UIFont, insets: UIEdgeInsets)
//    {
//        super.init()
//        
//        self.color = color
//        self.font = font
//        self.insets = insets
//        
//        _paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as? NSMutableParagraphStyle
//        _paragraphStyle?.alignment = .Center
//    }
//    
//    open override var size: CGSize { return _size; }
//    
//    open override func draw(context: CGContext, point: CGPoint)
//    {
//        if (labelns == nil)
//        {
//            return
//        }
//        
//        var rect = CGRect(origin: point, size: _size)
//        rect.origin.x -= _size.width / 2.0
//        rect.origin.y -= _size.height
//        
//        CGContextSaveGState(context)
//        
//        CGContextSetFillColorWithColor(context, color?.CGColor)
//        CGContextBeginPath(context)
//        CGContextMoveToPoint(context,
//                             rect.origin.x,
//                             rect.origin.y)
//        CGContextAddLineToPoint(context,
//                                rect.origin.x + rect.size.width,
//                                rect.origin.y)
//        CGContextAddLineToPoint(context,
//                                rect.origin.x + rect.size.width,
//                                rect.origin.y + rect.size.height - arrowSize.height)
//        CGContextAddLineToPoint(context,
//                                rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
//                                rect.origin.y + rect.size.height - arrowSize.height)
//        CGContextAddLineToPoint(context,
//                                rect.origin.x + rect.size.width / 2.0,
//                                rect.origin.y + rect.size.height)
//        CGContextAddLineToPoint(context,
//                                rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
//                                rect.origin.y + rect.size.height - arrowSize.height)
//        CGContextAddLineToPoint(context,
//                                rect.origin.x,
//                                rect.origin.y + rect.size.height - arrowSize.height)
//        CGContextAddLineToPoint(context,
//                                rect.origin.x,
//                                rect.origin.y)
//        CGContextFillPath(context)
//        
//        rect.origin.y += self.insets.top
//        rect.size.height -= self.insets.top + self.insets.bottom
//        
//        UIGraphicsPushContext(context)
//        
//        labelns?.drawInRect(rect, withAttributes: _drawAttributes)
//        
//        UIGraphicsPopContext()
//        
//        CGContextRestoreGState(context)
//    }
//    
//    open override func refreshContent(entry: ChartDataEntry, highlight: ChartHighlight)
//    {
//        let label = entry.value.description
//        labelns = label as NSString
//        
//        _drawAttributes.removeAll()
//        _drawAttributes[NSFontAttributeName] = self.font
//        _drawAttributes[NSParagraphStyleAttributeName] = _paragraphStyle
//        
//        _labelSize = labelns?.sizeWithAttributes(_drawAttributes) ?? CGSizeZero
//        _size.width = _labelSize.width + self.insets.left + self.insets.right
//        _size.height = _labelSize.height + self.insets.top + self.insets.bottom
//        _size.width = max(minimumSize.width, _size.width)
//        _size.height = max(minimumSize.height, _size.height)
//    }
//}
