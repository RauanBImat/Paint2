//  PaintView.swift
//  Homework 12
//
//  Created by Рауан Абишев on 17.05.2022.
//

import UIKit

class PaintView: UIView {
    
    // MARK: - Properties
    
    var toolType: ToolType = .circle
    var colorType: ColorType = .blue
    var isFilled: Bool = true
    private var shapes: [(path: UIBezierPath, isFilled: Bool, colorType: ColorType)] = []
    private var initialPoint: CGPoint?
    private var initPoint: CGPoint?
    
    // MARK: - Lifecycle
    
    override func draw(_ rect: CGRect) {
        for shape in shapes {
            shape.colorType.color.set()
            shape.path.lineWidth = 2.0
            if shape.isFilled {
                shape.path.fill()
            }
            shape.path.stroke()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        initialPoint = touches.first?.location(in: self)
        initPoint = touches.first?.location(in: self)
    }
    
  
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            let endPoint = touches.first?.location(in: self),
            let initialPoint = initialPoint
        else { return }
        
        switch toolType {
        case .circle:
            drawCircle(initialPoint, endPoint)
        case .rectangle:
            drawRectangle(initialPoint, endPoint)
        case .triangle:
            drawTriangle(initialPoint, endPoint)
       
        }
    }
    
    // MARK: - Methods
    
    public func undo() {
        shapes.removeLast()
        setNeedsDisplay()
    }
    
    private func drawCircle(_ firstPoint: CGPoint, _ secondPoint: CGPoint) {
        let circleCenter = CGPoint(
            x: (firstPoint.x + secondPoint.x) / 2,
            y: (firstPoint.y + secondPoint.y) / 2
        )
        let deltaX = secondPoint.x - firstPoint.x
        let deltaY = secondPoint.y - firstPoint.y
        let circleRadius: CGFloat = sqrt(deltaX * deltaX + deltaY * deltaY) / 2
        let circle = UIBezierPath(
            arcCenter: circleCenter,
            radius: circleRadius,
            startAngle: 0.0,
            endAngle: CGFloat(2 * Double.pi),
            clockwise: false
        )
        shapes.append((isFilled: isFilled, path: circle, colorType: colorType))
        setNeedsDisplay()
    }
    
    private func drawRectangle(_ firstPoint: CGPoint, _ secondPoint: CGPoint) {
        let originPoint = CGPoint(
            x: firstPoint.x,
            y: firstPoint.y
        )
        let rectSize = CGSize(
            width: (secondPoint.x - firstPoint.x),
            height: (secondPoint.y - firstPoint.y)
        )
        let aRectangle = CGRect(origin: originPoint, size: rectSize)
        let rectangle = UIBezierPath(rect: aRectangle)
        shapes.append((isFilled: isFilled, path: rectangle, colorType: colorType))
        setNeedsDisplay()
    }
    
    private func drawTriangle(_ firstPoint: CGPoint, _ secondPoint: CGPoint) {
        let triangle = UIBezierPath()
        triangle.move(to: CGPoint(x: firstPoint.x, y: firstPoint.y))
        triangle.addLine(to: CGPoint(x: firstPoint.x, y: secondPoint.y))
        triangle.addLine(to: CGPoint(x: secondPoint.x, y: secondPoint.y))
        shapes.append((isFilled: isFilled, path: triangle, colorType: colorType))
        setNeedsDisplay()
    }
    
    private func drawAnimatedWithPen(_ firstPoint: CGPoint, _ secondPoint: CGPoint) {
        let line = UIBezierPath()
        line.move(to: firstPoint)
        line.addLine(to: secondPoint)
        shapes.append((isFilled: isFilled, path: line, colorType: colorType))
        setNeedsDisplay()
    }
    
}
