//
//  DrawView.swift
//  TouchTracker
//
//  Created by 전소영 on 2021/05/31.
//

import UIKit

class DrawView: UIView {
//    var currentLine: Line?
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()
    var angles = [CGFloat]()
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func strokeLine(line: Line) {
//        let path = UIBezierPath()
////        path.lineWidth = 10
//        path.lineWidth = lineThickness
//        path.lineCapStyle = CGLineCap.round
//
//        path.move(to: line.begin)
//        path.addLine(to: line.end)
//        path.stroke()
        
        drawArc(centerPoint: CGPoint(x: min(line.begin.x, line.end.x) + abs((line.end.x - line.begin.x) / 2), y: min(line.begin.y, line.end.y) + abs((line.end.y - line.begin.y) / 2)), startPoint: line.begin, endPoint: line.end, clockwise: true)
        drawArc(centerPoint: CGPoint(x: min(line.begin.x, line.end.x) + abs((line.end.x - line.begin.x) / 2), y: min(line.begin.y, line.end.y) + abs((line.end.y - line.begin.y) / 2)), startPoint: line.begin, endPoint: line.end, clockwise: false)
        print("centerPoint: \(CGPoint(x: min(line.begin.x, line.end.x) + abs((line.end.x - line.begin.x) / 2), y: min(line.begin.y, line.end.y) + abs((line.end.y - line.begin.y) / 2)))")
        
//        drawArc(centerPoint: CGPoint(x: 100, y: 100), startPoint: CGPoint(x: 50, y: 50), endPoint: CGPoint(x: 250, y: 250), clockwise: true)
//        drawArc(centerPoint: CGPoint(x: 150, y: 150), startPoint: CGPoint(x: 50, y: 50), endPoint: CGPoint(x: 150, y: 150), clockwise: false)
    }
    
    func drawArc(centerPoint: CGPoint, startPoint: CGPoint, endPoint: CGPoint, clockwise: Bool) {
        let radius = getRadius(center: centerPoint, start: startPoint)
        let start = getAngle(center: centerPoint, point: startPoint, radius: radius)
        let end = getAngle(center: centerPoint, point: endPoint, radius: radius)

        let arcPath = UIBezierPath()
        arcPath.move(to: startPoint)
        arcPath.addArc(withCenter: centerPoint, radius: radius, startAngle: start, endAngle: end, clockwise: clockwise)

        let arcLayer = CAShapeLayer()
        arcLayer.path = arcPath.cgPath
        arcLayer.lineWidth = 3
        arcLayer.strokeEnd = 1
        arcLayer.strokeColor = UIColor.red.cgColor
        arcLayer.fillColor = UIColor.clear.cgColor
        arcLayer.fillMode = .forwards

        self.layer.addSublayer(arcLayer)
    }
    
    override func draw(_ rect: CGRect) {
//        UIColor.black.setStroke()
        
        for line in finishedLines {
            var angle = line.begin.angle(to: line.end)
            if angle >= 0 && angle <= 90 {
                finishedLineColor.setStroke()
            } else {
                currentLineColor.setStroke()
            }
            strokeLine(line: line)
        }
        
//        UIColor.red.setStroke()
//        currentLineColor.setStroke()
//        for (_, line) in currentLines {
//            strokeLine(line: line)
//        }
        
//        if let line = currentLine {
//            UIColor.red.setStroke()
//            strokeLine(line: line)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        let touch = touches.first!
//        let location = touch.location(in: self)
//
//        currentLine = Line(begin: location, end: location)
        
        for touch in touches {
            let location = touch.location(in: self)
            
            let newLine = Line(begin: location, end: location)
            
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first!
//        let locatioin = touch.location(in: self)
//
//        currentLine?.end = locatioin
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if var line = currentLine {
//            let touch = touches.first!
//            let location = touch.location(in: self)
//            line.end = location
//
//            finishedLines.append(line)
//        }
//        currentLine = nil
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in: self)
                
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        
        setNeedsDisplay()
    }
    
    func getRadius(center: CGPoint, start: CGPoint) -> CGFloat {
        let xDist: CGFloat = start.x - center.x
        let yDist: CGFloat = start.y - center.y

        let radius: CGFloat = sqrt((xDist * xDist) + (yDist * yDist))

        return radius
    }
    
    func getAngle(center: CGPoint, point: CGPoint, radius: CGFloat) -> CGFloat {
        let origin = CGPoint(x: center.x + radius, y: center.y)

        let v1 = CGVector(dx: origin.x - center.x, dy: origin.y - center.y)
        let v2 = CGVector(dx: point.x - center.x, dy: point.y - center.y)

        let angle = atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)

        return angle
    }
}

extension CGFloat {
    var degrees: CGFloat {
        return self * CGFloat(180) / .pi
    }
}

extension CGPoint {
    func angle(to comparisonPoint: CGPoint) -> CGFloat {
        let originX = comparisonPoint.x - x
        let originY = comparisonPoint.y - y
        let bearingRadians = atan2f(Float(originY), Float(originX))
        var bearingDegrees = CGFloat(bearingRadians).degrees

        while bearingDegrees < 0 {
            bearingDegrees += 360
        }

        return bearingDegrees
    }
}
