//
//  DrawView.swift
//  TouchTracker
//
//  Created by 전소영 on 2021/05/31.
//

import UIKit
import Swift

class DrawView: UIView, UIGestureRecognizerDelegate {
    
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()
    var selectedLineIndex: Int? {
        didSet {
            if selectedLineIndex == nil {
                let menu = UIMenuController.shared
                menu.setMenuVisible(false, animated: true)
            }
        }
    }
    var moveRecognizer: UIPanGestureRecognizer!
    var flag = " "
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self,
                                                         action: #selector(doubleTap(gestureRecognizer:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(gestureRecognizer:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                               action: #selector(longPress(gestureRecognizer:)))
        addGestureRecognizer(longPressRecognizer)
        
        moveRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveLine(gestureRecognizer:)))
        moveRecognizer.delegate = self
        moveRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(moveRecognizer)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer
        otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
    }
    
    @objc func moveLine(gestureRecognizer: UIPanGestureRecognizer) {
        print("Recognized a pan")
        
        // If a line is selected...
        if let index = selectedLineIndex {
            // When the pan recognizer changes its position...
            if gestureRecognizer.state == .changed {
                // How far has the pan moved?
                let translation = gestureRecognizer.translation(in: self)
                
                // Add the translation to the current beginning and end points of the line
                // Make sure there are no copy and paste typos!
                finishedLines[index].begin.x += translation.x
                finishedLines[index].begin.y += translation.y
                finishedLines[index].end.x += translation.x
                finishedLines[index].end.y += translation.y
                
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
                flag = "move"
                // Redraw the screen
                setNeedsDisplay()
            }
        }
        else {
            flag = " "
            // If no line is selected, do not do anything
            return
        }
    }
    
    @objc func doubleTap(gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a double tap")
        
        selectedLineIndex = nil
        currentLines.removeAll(keepingCapacity: false)
        finishedLines.removeAll(keepingCapacity: false)
        setNeedsDisplay()
    }
    
    @objc func longPress(gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a long press")
        
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: self)
            selectedLineIndex = indexOfLineAtPoint(point: point)
            
            if selectedLineIndex != nil {
                currentLines.removeAll(keepingCapacity: false)
            }
        }
        else if gestureRecognizer.state == .ended {
            selectedLineIndex = nil
        }
        
        setNeedsDisplay()
    }
    
    @objc func tap(gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a tap")
        
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLineAtPoint(point: point)
        
        // Grab the menu controller
        let menu = UIMenuController.shared
        
        if selectedLineIndex != nil {
            
            // Make ourselves the target of menu item action messages
            becomeFirstResponder()
            
            // Create a new "Delete" UIMenuItem
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(deleteLine))
            menu.menuItems = [deleteItem]
            
            // Tell the menu where it should come from and show it
            menu.setTargetRect(CGRect(x: point.x, y: point.y, width: 2, height: 2),
                               in: self)
            menu.setMenuVisible(true, animated: true)
        }
        else {
            // Hide the menu if no line is selected
            menu.setMenuVisible(false, animated: true)
        }
        
        setNeedsDisplay()
    }
    
    @objc func deleteLine(sender: AnyObject) {
        // Remove the selected line from the list of finishedLines
        if let index = selectedLineIndex {
            finishedLines.remove(at: index)
            selectedLineIndex = nil
            
            // Redraw everything
            setNeedsDisplay()
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    func strokeLine(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = 10
        path.lineCapStyle = CGLineCap.round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    func indexOfLineAtPoint(point: CGPoint) -> Int? {
        
        // Find a line close to point
        for (index, line) in finishedLines.enumerated() {
            let begin = line.begin
            let end = line.end
            
            // Check a few points on the line
            
            for t in stride(from: CGFloat(0), to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
                // If the tapped point is within 20 points, let's return this line
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
        }
        
        // If nothing is close enough to the tapped point, then we did not select a line
        return nil
    }
    
    override func draw(_ rect: CGRect) {
        // Draw finished lines in black
        UIColor.black.setStroke()
        for line in finishedLines {
            strokeLine(line: line)
        }
        
        // Draw current lines in red
        UIColor.red.setStroke()
        if flag != "move" {
            for (_, line) in currentLines {
                strokeLine(line: line)
            }
        }
        
        if let index = selectedLineIndex {
            UIColor.green.setStroke()
            let selectedLine = finishedLines[index]
            strokeLine(line: selectedLine)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentLines.removeAll(keepingCapacity: false)
        if flag != "move" {
            for touch in touches {
                let location = touch.location(in: self)
                
                let newLine = Line(begin: location, end: location)
                
                let key = NSValue(nonretainedObject: touch)
                currentLines[key] = newLine
            }
        setNeedsDisplay()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if flag != "move" {
            for touch in touches {
                let key = NSValue(nonretainedObject: touch)
                currentLines[key]?.end = touch.location(in: self)
            }
            
        setNeedsDisplay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if flag != "move" {
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
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        currentLines.removeAll()
        
        setNeedsDisplay()
    }
}
