//
//  GridView.swift
//  Assignment3
//
//  Created by Sean Valois on 3/26/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

@IBDesignable class GridView: UIView {

    @IBInspectable var livingColor = UIColor.black
    @IBInspectable var emptyColor = UIColor.white
    @IBInspectable var bornColor = UIColor.gray
    @IBInspectable var diedColor = UIColor.white
    @IBInspectable var gridColor = UIColor.black
    
    @IBInspectable var size = 20
    
    @IBInspectable var gridWidth = CGFloat(3)
    
    struct grid {
        var rows = gridWidth
        var cols = gridWidth
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let size = CGSize (
            width: rect.size.width / gridWidth
            height: rect.size.height / gridWidth
        )
        
        let base = rect.origin
        (0..<gridWidth).forEach { i in
            (0..<gridWidth) { j in
                let origin = CGPoint (
                    x: base.x + (CGFloat(i) * size.width),
                    y: base.y + (CGFloat(j) * size.height)
                )
                let subRect = CGRect (
                    origin: origin,
                    size: size
                )
                if arc4random_uniform(2) == 1 {
                    let path = UIBezierPath (ovalIn: subRect)
                    fillColor.setFill()
                    path.fill()
                }
            }
        }
        
        let lineWidth: CGFloat = 8.0
        
        let verticlePath = UIBezierPath()
        var start = CGPoint(
            x: rect.origin.x + rect.size.width / 2.0,
            y: rect.origin.y
        )
        var end = CGPoint(
            x: rect.origin.x + rect.size.width / 2.0,
            y: rect.origin.y + rect.size.height
        )
        
        verticlePath.lineWidth = lineWidth
        verticlePath.move(to: start)
        verticlePath.addLine(to: end)
        verticlePath.stroke()
       
        let horizontalPath = UIBezierPath()
        start = CGPoint(
            x: rect.origin.x,
            y: rect.origin.y + rect.size.height / 2.0
        )
        end = CGPoint(
            x: rect.origin.x + rect.size.width,
            y: rect.origin.y + rect.size.height / 2.0
        )
        
        horizontalPath.lineWidth = lineWidth
        horizontalPath.move(to: start)
        horizontalPath.addLine(to: end)
        horizontalPath.stroke()
        
    }
    

}
