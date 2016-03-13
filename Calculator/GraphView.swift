//
//  GraphView.swift
//  Play
//
//  Created by Junor on 16/3/13.
//  Copyright © 2016年 Junor. All rights reserved.
//

import UIKit


protocol GraphViewDataSource: class {
    
    func y(x: CGFloat) -> CGFloat?
}


@IBDesignable class GraphView: UIView {
    
    weak var dataSource: GraphViewDataSource?
    
    @IBInspectable var scale: CGFloat = 50.0 { didSet { setNeedsDisplay() } }

    var lineWidth: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    var color: UIColor = UIColor.purpleColor() { didSet { setNeedsDisplay() } }
    var viewCenter: CGPoint { return convertPoint(center, fromView: superview) }
    var origin: CGPoint = CGPoint() {
        didSet {
            resetOrigin = false
            setNeedsDisplay()
        }
    }
    
    private var resetOrigin: Bool = true {
        didSet {
            if resetOrigin {
                setNeedsDisplay()
            }
        }
    }
    
//    override func awakeFromNib() {
//        self.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: "pinchAction:"))
//        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "panAction:"))
//        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "tapAction:")
//        doubleTapRecognizer.numberOfTapsRequired = 2
//        self.addGestureRecognizer(doubleTapRecognizer)
//        
//    }

    override func drawRect(rect: CGRect) {
        if resetOrigin {
            origin = center
        }
        AxesDrawer(contentScaleFactor: contentScaleFactor).drawAxesInRect(bounds, origin: origin, pointsPerUnit: scale)
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        color.set()
        var firstValue = true
        var point = CGPoint()
        for i in 0...Int(bounds.size.width * contentScaleFactor) {
            point.x = CGFloat(i) / contentScaleFactor
            if let y = dataSource?.y((point.x - origin.x) / scale) {
                if !y.isNormal && !y.isZero {
                    continue
                }
                point.y = origin.y - y * scale
                if firstValue {
                    path.moveToPoint(point)
                    firstValue = false
                } else {
                    path.addLineToPoint(point)
                }
            } else {
                firstValue = true
            }
        }
        path.stroke()
    }
    
    
    // MARK: - Gesture Aaction
    
    func pinchAction(recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .Changed {
            scale *= recognizer.scale
            recognizer.scale = 1.0
        }
    }
    
    func panAction(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = recognizer.translationInView(self)
            origin.x += translation.x
            origin.y += translation.y
            recognizer.setTranslation(CGPointZero, inView: self)
        default: break
        }
    }
    
    func tapAction(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            origin = recognizer.locationInView(self)
        }
    }

}
