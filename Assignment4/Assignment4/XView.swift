//
//  XView.swift
//  Lecture6
//
//  Created by Van Simmons on 3/6/17. Updated by Sean Valois 4/20/217
//  Copyright © 2017 Harvard University. All rights reserved.
//
import UIKit

public protocol GridViewDataSource {
    subscript (row: Int, col: Int) -> CellState { get set }
}

@IBDesignable class XView: UIView {
    
    @IBInspectable var fillColor = UIColor.darkGray
    @IBInspectable var gridRows: Int = 10
    @IBInspectable var gridCols: Int = 10

    @IBInspectable var livingColor: UIColor = UIColor.green
    @IBInspectable var emptyColor: UIColor = UIColor.clear
    @IBInspectable var bornColor: UIColor = UIColor.yellow
    @IBInspectable var diedColor: UIColor = UIColor.black
    @IBInspectable var gridColor: UIColor = UIColor.black
    @IBInspectable var gridWidth: CGFloat = CGFloat(1.0)
    
    var drawGrid: GridViewDataSource?
    
    var xColor = UIColor.black
    var xProportion = CGFloat(1.0)
    var widthProportion = CGFloat(0.05)
    
    override func draw(_ rect: CGRect) {
        let drawSize = CGSize(
            width: rect.size.width / CGFloat(gridCols),
            height: rect.size.height / CGFloat(gridRows)
        )
        let base = rect.origin
        
        (0 ... gridCols).forEach {
            drawLine(
                start: CGPoint(
                    x: rect.origin.x + (CGFloat($0)*drawSize.width),
                    y: rect.origin.y),
                end: CGPoint(
                    x: rect.origin.x + (CGFloat($0)*drawSize.width),
                    y: rect.origin.y + rect.size.height),
                lineWidth: gridWidth,
                lineColor: gridColor)
        }
        (0 ... gridRows).forEach {
            drawLine(
                start: CGPoint(
                    x: rect.origin.x,
                    y: rect.origin.y + (CGFloat($0)*drawSize.height)),
                end: CGPoint(
                    x: rect.origin.x + rect.size.width,
                    y: rect.origin.y + (CGFloat($0)*drawSize.height)),
                lineWidth: gridWidth,
                lineColor: gridColor)
        }
        
        (0 ..< gridCols).forEach { i in
            (0 ..< gridRows).forEach { j in
                let origin = CGPoint(
                    x: base.x + (CGFloat(i) * drawSize.width) + gridWidth,
                    y: base.y + (CGFloat(j) * drawSize.height) + gridWidth
                )
                
                let subDrawSize = CGSize(
                    width: rect.size.width / CGFloat(gridCols) - 2*gridWidth,
                    height: rect.size.height / CGFloat(gridRows) - 2*gridWidth
                )
                
                let subRect = CGRect(
                    origin: origin,
                    size: subDrawSize
                )
                let path = UIBezierPath(ovalIn: subRect)
                
                
                if let drawGrid = drawGrid {
                    
                    // Set the color based on the CellState using the description method
                    switch drawGrid[(j,i)].description()
                    {
                    case "empty":
                        emptyColor.setFill()
                    case "alive":
                        livingColor.setFill()
                    case "born":
                        bornColor.setFill()
                    case "dead":
                        diedColor.setFill()
                    default:
                        emptyColor.setFill()
                    }
                    
                    path.fill()
                }
            }
        }
    }
    
    

    
    func drawLine(start: CGPoint, end: CGPoint, lineWidth: CGFloat, lineColor: UIColor) {
        let path = UIBezierPath()
        
        path.lineWidth = 2.0
        path.move(to: start)
        path.addLine(to: end)
        UIColor.cyan.setStroke()
        path.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = nil
        let engine = standardEngine.mapNew()
        engine.engineUpdateNC()
    }
    
    // Updated since class
    var lastTouchedPosition: GridPosition?
    
    func process(touches: Set<UITouch>) -> GridPosition? {
        let touchY = touches.first!.location(in: self.superview).y
        let touchX = touches.first!.location(in: self.superview).x
        guard touchX > frame.origin.x && touchX < (frame.origin.x + frame.size.width) else { return nil }
        guard touchY > frame.origin.y && touchY < (frame.origin.y + frame.size.height) else { return nil }
        
        guard touches.count == 1 else { return nil }
        let pos = convert(touch: touches.first!)
        
        //************* IMPORTANT ****************
        guard lastTouchedPosition?.row != pos.row
            || lastTouchedPosition?.col != pos.col
            else { return pos }
        //****************************************
        
        if drawGrid != nil {
            drawGrid![pos.row, pos.col] = drawGrid![pos.row, pos.col].isAlive ? .empty : .alive
            setNeedsDisplay()
        }
        return pos
    }
    
    func convert(touch: UITouch) -> GridPosition {
        let touchY = touch.location(in: self).y
        let gridHeight = frame.size.height
        let row = touchY / gridHeight * CGFloat(gridRows)
        
        let touchX = touch.location(in: self).x
        let gridWidth = frame.size.width
        let col = touchX / gridWidth * CGFloat(gridCols)
        
        return GridPosition(row: Int(row), col: Int(col))
    }
}
